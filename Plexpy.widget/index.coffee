options =
  widgetEnable: true
  avatarEnable: true
  apiKey: 'YourPlexPyAPIKey'
  plexpyHost: 'YourPlexPyHost'
  protocol: 'https'

StringToHHMMSS = (str) ->
  sec_num = parseInt(str, 10)
  hours   = Math.floor(sec_num / 3600)
  minutes = Math.floor((sec_num - (hours * 3600)) / 60)
  seconds = sec_num - (hours * 3600) - (minutes * 60)

  if (hours < 10)
    hours = "0" + hours
  if (minutes < 10)
    minutes = "0" + minutes
  if (seconds < 10)
    seconds = "0" + seconds
  if (hours != "00")
    hours + ':' + minutes + ':' + seconds
  else
    minutes + ':' + seconds

refreshFrequency: '30s'

options: options

command: "curl -fs '#{options.protocol}://#{options.plexpyHost}/api/v2\?apikey\=#{options.apiKey}\&cmd\=get_activity'"

style: """
  position: absolute
  top: 0px
  left: 0px
  -webkit-backdrop-filter: none
  font-family: Helvetica Neue

  .session
    margin-bottom: 15px

  .progressWrapper
    width: 100%
    height: 5px
    background: #000
    border-radius: 15px

  .progress
    background: #faa732
    height: 5px

  .plexpyWrapper
    margin: 30px
    color: #fff
    width: 400px
    -webkit-text-shadow: 0px 0px 5px rgba(0,0,0,0.75)
    -moz-text-shadow: 0px 0px 5px rgba(0,0,0,0.75)
    text-shadow: 0px 0px 5px rgba(0,0,0,0.75)

    .playbackInfo
      font-size: 10pt
      color: rgba(#fff, 0.75)
      margin-bottom: 5px
      display: flex
      text-transform: capitalize
      .state
        flex-grow: 1
        flex-basis: 33%
        text-align: left
      .duration
        flex-grow: 1
        flex-basis: 33%
        text-align: right
      .quality
        flex-grow: 1
        flex-basis: 33%
        text-align: center
    .info
      display: flex
    .meta
      flex-grow: 8
    .title
      font-size: 12pt
      margin-top: 5px
    .user
      font-size: 10pt
      color: rgba(#fff, 0.75)
      margin-top: 2px
    .avatar
      margin-top: 5px
      margin-right: 10px
      border-radius: 10%
      width: 35px
      height: 35px
      -webkit-box-shadow: 0px 0px 20px -2px rgba(0,0,0,0.75)
      -moz-box-shadow: 0px 0px 20px -2px rgba(0,0,0,0.75)
      box-shadow: 0px 0px 20px -2px rgba(0,0,0,0.75)


"""

render: (_) -> """
  <div class="plexpyWrapper">
  </div>
"""

renderSession: (session) -> """
  <div class="session">
    <div class="playbackInfo">
      <div class="state">#{session.state}</div>
      <div class="quality">#{session.transcode_decision}</div>
      <div class="duration">#{StringToHHMMSS(session.view_offset/1000)}/#{StringToHHMMSS(session.duration/1000)}</div>
    </div>
    <div class="progressWrapper">
      <div class="progress" style="width: #{session.progress_percent}%"></div>
    </div>
    <div class="info">
      <img class="avatar" src="#{session.user_thumb}" style="display: #{if options.avatarEnable then 'block' else 'none'}" />
      <div class="meta">
        <div class="title">#{session.full_title}</div>
        <div class="user">#{session.friendly_name} - #{session.platform}</div>
      </div>
    </div>
  </div>
"""

update: (output, domEl) ->
  if options.widgetEnable
    try
      response = JSON.parse(output).response
      sessions = response.data.sessions
      sessionsDom = (this.renderSession(session) for session in sessions)
      $(domEl).find('.plexpyWrapper').html(sessionsDom)
    catch error
      console.log(error)
