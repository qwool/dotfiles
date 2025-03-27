function fish_prompt
    set --global lambda_color_pwd yellow
    set --global lambda_color_duration cyan
    set --global lambda_color_prompt white
    set --global lambda_prompt_character λ

    set prompt_pwd (string replace -- ~ \~ $PWD)

    function prompt_postexec --on-event fish_postexec
        set --erase _prompt_cmd_duration
        test "$CMD_DURATION" -lt 1000 && return

        set secs (math --scale=1 $CMD_DURATION/1000 % 60)
        set mins (math --scale=0 $CMD_DURATION/60000 % 60)
        set hours (math --scale=0 $CMD_DURATION/3600000)

        set out ""
        test $hours -gt 0; and set out "$out$hours""h"
        test $mins -gt 0; and set out "$out$mins""m"
        test $secs -gt 0; and set out "$out$secs""s"

        set --global _prompt_cmd_duration "$out "
    end

    echo -ne (set_color $lambda_color_pwd)$prompt_pwd" "
    echo -ne (set_color $lambda_color_duration)$_prompt_cmd_duration
    echo -ne (set_color $lambda_color_prompt)$lambda_prompt_character(set_color normal)" "
end

