# Genie_11708404965191645296 

function func_6c4e6e72c95402bc36a054258afd9227e473feb3(
    context = Genie.Renderer.vars(:context),
)::String

    """
              \n    Stipple.init({theme: 'stipple-blue'});\n    var EdgeDetectionModel = new Vue({\"el\":\"#EdgeDetectionModel\",\"mixins\":[watcherMixin, reviveMixin],\"data\":{\"output\":\"\",\"isready\":false,\"isprocessing\":false,\"input\":\"\"}});\n      EdgeDetectionModel.\$watch(function(){return this.output}, _.debounce(function(newVal, oldVal){\n    Genie.WebChannels.sendMessageTo(CHANNEL, 'watchers', {'payload': {'field':'output', 'newval': newVal, 'oldval': oldVal}});\n  }, 300), {deep: true});\n\n\n  EdgeDetectionModel.\$watch(function(){return this.input}, _.debounce(function(newVal, oldVal){\n    Genie.WebChannels.sendMessageTo(CHANNEL, 'watchers', {'payload': {'field':'input', 'newval': newVal, 'oldval': oldVal}});\n  }, 300), {deep: true});\n\n\n  EdgeDetectionModel.\$watch(function(){return this.isready}, _.debounce(function(newVal, oldVal){\n    Genie.WebChannels.sendMessageTo(CHANNEL, 'watchers', {'payload': {'field':'isready', 'newval': newVal, 'oldval': oldVal}});\n  }, 300), {deep: true});\n\n\n  EdgeDetectionModel.\$watch(function(){return this.isprocessing}, _.debounce(function(newVal, oldVal){\n    Genie.WebChannels.sendMessageTo(CHANNEL, 'watchers', {'payload': {'field':'isprocessing', 'newval': newVal, 'oldval': oldVal}});\n  }, 300), {deep: true});\n\n\n\nwindow.parse_payload = function(payload){\n  if (payload.key) {\n    if (payload.revive) { \n      window.EdgeDetectionModel.revive_payload(payload)\n    }\n    if (payload.mode==\"dict\") {\n      window.EdgeDetectionModel.updateFieldAt(payload.key, payload.value, payload.keys);\n    } else {\n      window.EdgeDetectionModel.updateField(payload.key, payload.value);\n    }\n  }\n}\n\nfunction app_ready() {\n  if ((document.readyState === \"complete\" || document.readyState === \"interactive\") && Genie.WebChannels.socket.readyState === 1) {\n    Genie.WebChannels.sendMessageTo(CHANNEL, 'watchers', {'payload': {'field':'isready', 'newval': true, 'oldval': false}});\nEdgeDetectionModel.isready = true;\n\n    console.log('App ready');\n  } else {\n    console.log('App starting');\n    setTimeout(app_ready, Genie.Settings.webchannels_timeout);\n  }\n};\n\nwindow.onload = function() {\n  EdgeDetectionModel.\$forceUpdate();\n  console.log(\"Loading completed\");\n  app_ready();\n}\n
              """
end
