# Genie_1677815450654256935 

function func_b57699b97e296cbed0b881eccd6095d5973ac432(
    context = Genie.Renderer.vars(:context),
)::String

    """
              const watcherMixin = {\n  methods: {\n    \$withoutWatchers: function (cb, filter) {\n      let ww = (filter === null) ? this._watchers : [];\n\n      if (typeof(filter) == \"string\") {\n        this._watchers.forEach((w) => { if (w.expression == filter) {ww.push(w)} } )\n      } else { // if it is a true regex\n        this._watchers.forEach((w) => { if (w.expression.match(filter)) {ww.push(w)} } )\n      }\n\n      const watchers = ww.map((watcher) => ({ cb: watcher.cb, sync: watcher.sync }));\n\n      for (let index in ww) {\n        ww[index].cb = () => null;\n        ww[index].sync = true;\n      }\n\n      cb();\n\n      for (let index in ww) {\n        ww[index].cb = watchers[index].cb;\n        ww[index].sync = watchers[index].sync;\n      }\n\n    },\n\n    updateField: function (field, newVal) {\n      try {\n        this.\$withoutWatchers(()=>{this[field]=newVal},\"function(){return this.\" + field + \"}\");\n      } catch(ex) {\n        console.log(ex);\n      }\n    }\n  }\n}\nconst reviveMixin = {\n  methods: {\n    revive_payload: function(obj) {\n      if (typeof obj === 'object') {\n        for (var key in obj) {\n          if ( (typeof obj[key] === 'object') && (obj[key]!=null) && !(obj[key].jsfunction) ) {\n            this.revive_payload(obj[key])\n          } else {\n            if ( (obj[key]!=null) && (obj[key].jsfunction) ) {\n              obj[key] = Function(obj[key].jsfunction.arguments, obj[key].jsfunction.body)\n              if (key=='stipplejs') { obj[key](); }\n            }\n          }\n        }\n      }\n      return obj;\n    }\n  }\n}\n\n    var EdgeDetectionCardDemo = new Vue({\"el\":\"#EdgeDetectionCardDemo\",\"mixins\":[watcherMixin, reviveMixin],\"data\":{\"process\":false}});\n      EdgeDetectionCardDemo.\$watch(function(){return this.process}, _.debounce(function(newVal, oldVal){\n    Genie.WebChannels.sendMessageTo(window.Genie.Settings.webchannels_default_route, 'watchers', {'payload': {'field':'process', 'newval': newVal, 'oldval': oldVal}});\n  }, 300), {deep: true});\n\n\n\nwindow.parse_payload = function(payload){\n  if (payload.key) {\n    window.EdgeDetectionCardDemo.revive_payload(payload)\n    window.EdgeDetectionCardDemo.updateField(payload.key, payload.value);\n  }\n}\n\nwindow.onload = function() {\n  console.log(\"Loading completed\");\n  EdgeDetectionCardDemo.\$forceUpdate();\n}\n
              """
end
