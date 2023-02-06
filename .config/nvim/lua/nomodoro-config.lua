require('nomodoro').setup({
    work_time = 25,
    break_time = 5,
    menu_available = true,
    texts = {
        on_break_complete = "HORA DE FOCAR NO TRABALHO!",
        on_work_complete = "HORA DE FAZER UMA PAUSA!",
        status_icon = "羽",
        timer_format = '!%0M:%0S' -- To include hours: '!%0H:%0M:%0S'
    },
    on_work_complete = function()
      os.execute("notify-send 'Hora de descansar um pouco!' && paplay /usr/share/sounds/freedesktop/stereo/complete.oga")
    end,
    on_break_complete = function()
      os.execute("notify-send 'Hora de focar no trabalho!' && paplay /usr/share/sounds/freedesktop/stereo/complete.oga")
    end
})
