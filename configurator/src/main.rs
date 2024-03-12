use std::fs::File;
use std::io::Write;

use serde::{
    Deserialize,
};

#[derive(Deserialize)]
#[serde(rename_all = "kebab-case")]
struct Config {
    user: String,
    password: String,
    electrum_tor_address: String,
}

fn main() -> Result<(), anyhow::Error> {
    let config: Config = serde_yaml::from_reader(File::open("/data/start9/config.yaml")?)?;

    {
        let mut outfile = File::create("/data/fulcrum.conf")?;

        //let mut index_batch_size: String = "".to_string();
        //if config.index_batch_size.is_some() {
        //    index_batch_size = format!(
        //        "index_batch_size = {}",
        //        config.index_batch_size.unwrap()
        //    );
        //}

        //let mut index_lookup_limit: String = "".to_string();
        //if config.index_lookup_limit.is_some() {
        //    index_lookup_limit = format!(
        //        "index_batch_size = {}",
        //        config.index_lookup_limit.unwrap()
        //    );
        //}

        write!(
            outfile,
            include_str!("fulcrum-quick-config.conf"),
            bitcoin_rpc_user = config.user,
            bitcoin_rpc_pass = config.password,
            bitcoin_rpc_host = "bitcoind.embassy",
            bitcoin_rpc_port = 8332,
            electrum_tor_address = config.electrum_tor_address
        )?;
    }

    Ok(())
}