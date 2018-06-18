class TweetController < ApplicationController
    
    
    # board테이블에 있는 모든 tweet 내용을 보여줌
    def index
        @tweets = Board.all
        cookies[:user_name] = "송아람"
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
        flash[:success] = "새 글이 등록되었습니다."
        redirect_to "/tweet/#{t1.id}"
    end
    
    #Tweet 내용 삭제
    def destroy
    	tweet = Board.find(params[:id])
        tweet.destroy
        flash[:error] = "삭제가 완료되었습니다."
        
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
    	flash[:warning] = "수정이 완료되었습니다."
        
        redirect_to '/tweet'
    end
    
    #클릭한 tweet 내용 상세보기
    def show
        @tweet = Board.find(params[:id])
    end
end
