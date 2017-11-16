# Description:
#   Evaluate one line of Haskell
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot haskell <script> - Evaluate one line of Haskell
#
# Author:
#   edwardgeorge, slightly modified from code by jingweno

HASKELLJSON=""

module.exports = (robot) ->
  robot.respond /(eval)\s+(.*)/i, (msg)->
    script = msg.match[2]

    msg.http("http://tryhaskell.org/eval/")
      .query({exp: script})
      .get() (err, res, body) ->
        switch res.statusCode
          when 200
            result = JSON.parse(body)

            if result.error
              msg.reply result.error
            else
              if result.success
                e = result.success.expr
                v = result.success.value
                t = result.success.type
                o = "\`\`\`\n#{e}\n\t=> #{v} :: #{t}"
                msg.reply o
          else
            msg.reply "Unable to evaluate script: #{script}. Request returned with the status code: #{res.statusCode}"
