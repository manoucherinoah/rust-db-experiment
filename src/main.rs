use std::{process::exit, time::SystemTime, io::{self, Write}};

use chrono::{DateTime, Utc};
use clap::Parser;
use postgres::{Client, NoTls, Row, Column};
use tabled::builder::Builder;

/// Simple program to greet a person
#[derive(Parser, Default, Debug)]
struct Args {
    #[clap(long="mode")]
    mode: String, 
    #[clap(long="host")]
    host: String,
    #[clap(long="port")]
    port: String, 
    #[clap(long="user")]
    user: String, 
    #[clap(long="password")]
    password: String, 
    #[clap(long="database")]
    database: String,
}

fn main() {
    // parse arguments
    let args = Args::parse();
    // create connection
    let mut client: Client;
    client = Client::connect(format!("{}://{}:{}@{}:{}/{}", 
            args.mode,
            args.user,
            args.password,
            args.host,
            args.port,
            args.database,
        ).as_str(), 
        NoTls).unwrap();

    loop {
        // make and print the table
        match client.query(get_user_query().as_str(), &[]) {
            Ok(rows) => println!("{}", build_table(rows)),
            Err(_) => continue,
        }
    }
}

fn get_user_query() -> String {
    let stdin = io::stdin();
    let mut query = String::new();
    print!("query > ");
    io::stdout().flush().expect("could not flush");
    match stdin.read_line(&mut query) {
        Ok(_) => {
            if query == "/q" {
                exit(0);
            }

            query
        },
        Err(error) => {
            println!("error: {error}");
            String::new()
        },
    }
}

fn build_table(rows: Vec<Row>) -> String {
    // used to build the table
    let mut builder = Builder::default();
    
    // holds the header row
    let header_info = if rows.len() > 0 {
        build_header(&mut rows[0].columns(), &mut builder)
    } else {
        return String::from("NO ROWS FOUND");
    };

    for row in rows {
        let mut record: Vec<String> = Vec::new();
        let mut i = 0;

        // loop through all columns
        while i < header_info.len() {
            // grab the column type
            let col_type = match header_info.get(i) {
                Some(info_block) => &info_block[1],
                None => panic!("Indexed column no longer or does not exist"),
            };

            // find and parse the type of item it is
            if col_type.contains("int") {
                let value: i32 = row.get(i);
                record.insert(i, value.to_string());
            } else if col_type.contains("double") || col_type.contains("numeric") {
                let value: f64 = row.get(i);
                record.insert(i, value.to_string());
            } else if col_type.contains("char") {
                let value: String = row.get(i);
                record.insert(i, value);
            } else if col_type.contains("timestamp") || col_type.contains("date") {
                let value: SystemTime = row.get(i);
                let datetime: DateTime<Utc> = value.into();
                record.insert(i, format!("{}", datetime.format("%d/%m/%Y %T")));
            } else {
               println!("{col_type}");
            }

            // incriment counter
            i += 1;
        }

        builder.push_record(record);
    }

    builder.build().to_string()
}

fn build_header(columns: &[Column], builder: &mut Builder) -> Vec<[String; 2]> {
    let mut header_map: Vec<[String; 2]> = Vec::new();
    let mut index = 0;
    for col in columns {
        let info = [
            col.name().to_string(), // col name
            col.type_().to_string(), // data type
        ];
        header_map.insert(index, info);
        index += 1;
    }

    // grab the column names
    builder.set_header(header_map.iter().map(|item| &item[0]));
    header_map
}