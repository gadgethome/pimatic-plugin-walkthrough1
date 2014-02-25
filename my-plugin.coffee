# #Plugin template

# This is an plugin template and mini tutorial for creating pimatic plugins. It will explain the 
# basics of how the plugin system works and how a plugin should look like.

# ##The plugin code

# Your plugin must export a single function, that takes one argument and returns a instance of
# your plugin class. The parameter is an envirement object containing all pimatic related functions
# and classes. See the [startup.coffee](http://sweetpi.de/pimatic/docs/startup.html) for details.
module.exports = (env) ->

  # ###require modules included in pimatic
  # To require modules that are included in pimatic use `env.require`. For available packages take 
  # a look at the dependencies section in pimatics package.json

  # Require [convict](https://github.com/mozilla/node-convict) for config validation.
  convict = env.require "convict"

  # Require the [Q](https://github.com/kriskowal/q) promise library
  Q = env.require 'q'

  # Require the [cassert library](https://github.com/rhoot/cassert).
  assert = env.require 'cassert'

  # Include you own depencies with nodes global require function:
  #  
  #     someThing = require 'someThing'
  #  

  # ###MyPlugin class
  # Create a class that extends the Plugin class and implements the following functions:
  class MyPlugin extends env.plugins.Plugin

    # ####init()
    # The `init` function is called by the framework to ask your plugin to initialise.
    #  
    # #####params:
    #  * `app` is the [express] instance the framework is using.
    #  * `framework` the framework itself
    #  * `config` the properties the user specified as config for your plugin in the `plugins` 
    #     section of the config.json file 
    #     
    # 
    init: (app, @framework, config) =>
      # Require your config schema
      @conf = convict require("./my-plugin-config-schema")
      # and validate the given config.
      @conf.load(config)
      @conf.validate()
      # You can use `@conf.get "myConfigOption"` to get a config option.
      env.logger.info("Hello World")
    # ####createDevice()
    createDevice: (deviceConfig) =>
      # if the class option of the given config is...
      switch deviceConfig.class
        # ...matches your switch class
        when "YourTemperatureSensor" 
          # then create a instance of your device and register it
          @framework.registerDevice(new YourTemperatureSensor deviceConfig)
          # and return true.
          return true
        # ... not matching your classes
        else
          # then return false.
          return false


  class YourTemperatureSensor extends env.devices.TemperatureSensor
    temperature: null
 
    constructor: (deviceConfig) ->
        @name = "temperature"
        @id = "temperature"
        # update the temperature every 5 seconds
        setInterval( => 
          @doYourStuff()
        , 5000)
        super()
        
    doYourStuff: () ->
        temperature = 42
        @temperature = temperature
        @emit "temperature", temperature
 
    getTemperature: -> Q(@temperature)
    
  # ###Finally
  # Create a instance of my plugin
  myPlugin = new MyPlugin
  # and return it to the framework.
  return myPlugin