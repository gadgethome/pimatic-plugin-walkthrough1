# #my-device configuration options

# Declare your config option for MyDevice here. 

# Defines a `node-convict` config-schema and exports it.
module.exports =
  temperature:
    doc: "Some int option"
    format: "Number"
    default: 50