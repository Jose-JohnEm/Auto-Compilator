$Repo_Pwd = Dir.pwd
$Compilation = {compilator: "", src: [], includes: [], flags: [], name: ""}
$lang_files = {c: 0, cpp: 0}

def is_aDir?(directory)
    File.directory?(directory)
end

def PWD
    return "" if Dir.pwd == $Repo_Pwd 
    cur = Dir.pwd
    res = cur.delete_prefix($Repo_Pwd + "/")
    res << "/"
    return res
end

def try_push()
    to_include = "-I./" + PWD().delete_suffix("/")
    puts $Compilation[:includes].index(to_include)
    if $Compilation[:includes].index(to_include) == nil
        $Compilation[:includes].push(to_include) 
    end
end

def check_src_files_on(location)
    Dir.chdir location
    res = Dir.children(".").to_ary
    for i in 0...res.length
        if is_aDir?(res[i])
            check_src_files_on(res[i])
        end
        if res[i].end_with?(".c")
            $lang_files[:c] += 1
            $Compilation[:src].push(PWD() + res[i])
        end
        if res[i].end_with?(".cpp")
            $lang_files[:cpp] += 1
            $Compilation[:src].push(PWD() + res[i])
        end
        if res[i].end_with?(".h") or res[i].end_with?(".hpp")
            try_push()
        end
    end
    Dir.chdir "../"
end

def detect_language()
    if $lang_files[:cpp] > 0
        $Compilation[:compilator] = "g++"
        return "C++"
    end
    if $lang_files[:c] > 0
        $Compilation[:compilator] = "gcc"
        return "C"
    end
end

def debug_mode()
    puts "The compilator \"#{$Compilation[:compilator]}\" will be use"
    puts $Compilation[:includes].join(" ")
    puts $Compilation[:src].join(" ")
end

def flags_handle(av)
    debug_mode() if av.index("--debug") != nil and av.index("-D") != nil
    $Compilation[:name] = "-o " + av[av.index("--name") + 1] if av.index("--name") != nil
end

def main(av)
    check_src_files_on(".")
    detect_language()
    Dir.chdir($Repo_Pwd)
    flags_handle(av)
    command = "#{$Compilation[:compilator]} #{$Compilation[:src].join(" ")} #{$Compilation[:includes].join(" ")} #{$Compilation[:name]}"
    puts command
    system(command)
end

main(ARGV)
