local M = {}

M.path = 'html/sampler.html'
M.contents = [[
    <!DOCTYPE html>
    <html>
      <head>
        <meta charset="UTF-8" />
        <style>
          .main {
            display: flex;
            flex-direction: column;
            text-align: center;
          }
        </style>
      </head>
      <body>
        <h1>{{name}}</h1>
        <div class="main">
          <div style="background-color: "#{{background}}">background</div>
          <div style="background-color: "#{{foreground}}">foreground</div>
          <div style="background-color: "#{{selection_background}}">
            selection_background
          </div>
          <div style="background-color: "#{{selection_foreground}}">
            selection_foreground
          </div>
          {{#term}}
          <div style="background-color: "#{{value}}">term{{index}}</div>
          {{/term}}
        </div>
      </body>
    </html>
  ]]

return M
