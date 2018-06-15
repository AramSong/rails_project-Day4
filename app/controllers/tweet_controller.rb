class TweetController < ApplicationController
    
    
    # board테이블에 있는 모든 tweet 내용을 보여줌
    def index
        @tweets = Board.all
    end
    
    #새로운 Tweet 등록
    def new
    end
    
    #Tweet을 db 등록
    def create
    	t1 = Board.new
        t1.contents = params[:contents]
        t1.ip_address = request.ip
        t1.save
        
        redirect_to "/tweet"
    end
    
    #Tweet 내용 삭제
    def destroy
    	tweet = Board.find(params[:id])
        tweet.destroy
        
        redirect_to "/tweet"
    end
    
    #Tweet 내용 편집
    def edit
    	@tweet = Board.find(params[:id])
    end
    
    def update
        tweet = Board.find(params[:id])
        tweet.contents = params[:contents]
        tweet.ip_address = request.ip
    	tweet.save
        
        redirect_to '/tweet'
    end
    
    #클릭한 tweet 내용 상세보기
    def show
        @tweet = Board.find(params[:id])
    end
end
