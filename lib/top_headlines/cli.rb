class TopHeadlines::CLI

  def call
    system "clear"
    welcome_banner
    news_sources
    menu
    goodbye
  end

  def menu
    puts "Which source do you want to view? Alternatively, type 'all' to view all headlines or 'exit' to exit!"
    print "YOUR SELECTION: "
    @input = nil
    while @input != "EXIT"
      @input = gets.strip.upcase 
      if @input == "ALL"
        system "clear"
        list_all_headlines_banner
        list_all_headlines
        puts request_input_full_menu
        print "YOUR SELECTION: "
      elsif @input == "SOURCES"
        news_sources_banner
        news_sources
        puts request_input_full_menu
        print "YOUR SELECTION: "
      elsif TopHeadlines::Source.all.keys.include?(@input)
        system "clear"
        list_headlines_from_source
        open_article
      elsif @input != "EXIT"
        invalid_entry
      else
        nil
      end
    end
  end

  def time
    puts "Reporting live as of #{Time.now.strftime("%l:%M %p %Z on %a, %b #{Time.now.strftime("%e").to_i.ordinalize}, %Y")}"
    puts "\n"
  end

  def list_headlines_from_source
    puts "\n*** #{@input} ***"
    time
    TopHeadlines::Source.scrape_headlines(@input)[0,5].each_with_index {|headline, index| puts "#{index + 1}. #{headline}"}
    puts "\n"
  end

  def open_article
    puts "Select article number to open."
    print "YOUR SELECTION: "
    num = gets.strip

    if num.upcase == "EXIT"
      @input = num.upcase
    else 
      num = num.to_i
      while num.between?(1,5)
        url = TopHeadlines::Source.scrape_urls(@input)[num-1]
        headline = TopHeadlines::Source.scrape_headlines(@input)[num-1]
        
        puts "\nYou selected the #{num.ordinalize} headline: '#{headline}'."
        puts "Opening..."

        sleep(1)
        system("open", url)

        sleep(3)
        puts "\nSelect another article number to open."
        print "YOUR SELECTION: "
        num = gets.strip.to_i
      end
      invalid_entry
    end
  end

  def request_input_full_menu
    "Select a source, type 'sources' to view sources, type 'all' to view all headlines, or type 'exit' to exit."
  end

  def invalid_entry
    puts "\nINVALID: #{request_input_full_menu.downcase}"
    sleep(1)
    news_sources_banner
    news_sources
    print "YOUR SELECTION: "
  end

  def welcome_banner
    puts " ---------------------------"
    puts "| WELCOME TO TOP HEADLINES! |"
    puts " ---------------------------"
    time
  end

  def list_all_headlines_banner
    puts " -------------------------------"
    puts "| TOP HEADLINES & BREAKING NEWS |"
    puts " -------------------------------"
    time
  end

  def list_all_headlines
    TopHeadlines::Source.list_all_headlines
  end

  def news_sources_banner
    puts "\n"
    puts "NEWS SOURCES"
    puts "------------"
  end

  def news_sources
    TopHeadlines::Source.all.keys.each {|source| puts "*** #{source} ***"}
    puts "\n"
  end

  def goodbye
    system "clear"
    puts "\nThanks for visiting – see you next time!"

    puts <<-DOC
                                                                                                    
                          `.`                                                                       
                     ..` .-:-.                                                                      
                    `:::--:::.                                                                      
                 .---::::::::.                       ``````..``````                                 
                `-:::::::::::``````             ``...---------------..```                           
             .-..::::::::::::--:::-.        ``..-------------------------.``                        
             .:::::::::::::::::::-.`      `..-------------------------------.`                      
              -::::::::::::::::-`       `.------------------------------------.`                    
              `-::::::::::::::-`      `.----------------------------------------.`                  
               `-:::::::::::::.      `--------------------------------------------.`                
                `-::::::::::::.     .----------------------------------------------.`               
                 `--::::::::--`    .------------:oso/--------------/oso:------------.`              
                   ``.---..``     .-------------shhhh:-------------yhhhs-------------.              
                      .--.       `--------------:oss+--------------/sss:--------------`             
                      `---`      .----------------------------------------------------.             
                       `.--.`    .-----------------------------------------------------`            
                        `.---.```------------------------------------------------------`            
                          `..----------------------------------------------------------`            
                             ``..------------------------------------------------------`            
                                 .-----------------------------------------------------`            
                                 `--------------:/--------------------//--------------.             
                                  .------------+hhs/----------------/shho-------------`             
                                  `.------------+yhhs+:----------:/shhy+-------------`              
                                   `.------------:+yhhhyso++++oosyhhyo:-------------.               
                                    `.--------------:+syyyhhhhyyys+/---------------`                
                                     `.------------------:://:::-----------------.`                 
                                       `.--------------------------------------.`                   
                                         `.----------------------------------.`                     
                                           `..----------------------------..`                       
                                              ``..--------------------...`                          
                                                  ```.....----......``                              
                                                                                                    
    

    Image: VectorStock (https://www.vectorstock.com/royalty-free-vector/bye-goodbye-vector-6122218)
    ASCII Image Conversion: Patrik Roos (http://www.text-image.com/convert/ascii.html)
  
    TopHeadlines created by Zach Newburgh (http://www.zachnewburgh.com/)
    Copyright © 2016 Zach Newburgh
    
    DOC

  end
end