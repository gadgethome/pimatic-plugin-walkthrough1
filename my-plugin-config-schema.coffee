# #my-plugin configuration options

# Declare your config option for your plugin here. 

# Defines a `node-convict` config-schema and exports it.
module.exports =
  temperature:
    description: "temperature values (in °C) above this value will be discarded"
    type: Number
    unit: '°C'