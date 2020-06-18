$Repo_Pwd = Dir.pwd
$Compilation = {compilator: "", src: [], includes: [], flags: []}
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

def main()
    check_src_files_on(".")
    puts "The detected language is #{detect_language()}"
    puts "The compilator \"#{$Compilation[:compilator]}\" will be use"
    #puts $Compilation[:src].join(" ")
    Dir.chdir($Repo_Pwd)
    system("#{$Compilation[:compilator]} #{$Compilation[:src].join(" ")}")
end

main()
