$lang_files = {c: 0, cpp: 0}

def is_aDir?(directory)
    File.directory?(directory)
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
        end
    end
    Dir.chdir "../"
end

def main()
    check_src_files_on(".")
    puts $lang_files
end

main()
