## Day 3

* ORM(Object-Relational Mappings)
  - 객체와 관계형 데이터베이스 간의 매핑.
  - 각종 객체에 대한 코드를 별도로 작성(가독성 ↑)
  - DB에 종속적이지 않다.

### 간단과제

* ASK만들기

  * ask 모델과 ask_controller를 만든다.

    ask모델의 column

    * ip address
    * region
    * question

  * `/ask`  : 나에게 등록된 모든 질문을 출력

  * `/ask/new` : 새로운 질문을 작성하는 곳

    =>모델 만들고 route 설정하고 controller 작성하고 view 파일 만들기

    1.  $ rails  g  model ask
    2.  $ rails  g  controller ask
    3.  $ rake db:migrate

### 간단과제 2

* Twitter 처음부터 만들어보기
* Table(Model)명 : *board*

```
 $ rails g model board
 $ rails db:migrate
```

* Controller명 : TweetController

  ```
  $ rails g controller Tweet
  $ rails d controller TweetController	#controller 삭제 d: destroy
  ```

  * action : *index, show, new, create, edit, update, destroy*
  * `tweet_controller.rb`

  ```ruby
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
  ```

  

* View : *index,show,new,edit*

  * `views/tweet/index.html.erb`

  ```html
  <ul class="list-group">
      <% @tweets.reverse.each do |tweet| %>
          <li class="list-group-item"><%=tweet.question %>&nbsp&npsp
              <small><%=ask.ip_address%></small>
                  <p align="right">
                      <a class="btn btn-info" href="/tweet/<%=tweet.id%>">보기</a>
                  </p>
          </li>
      <% end %>
  </ul>        
  <div class="text-center"><br><br>
     <a href="/tweet/new" ><img src="Twitter_bird.png" width="32" height="32"></a><br><br>
  </div>
  
  ```

  * `views/tweet/show.html.erb`

  ```html
  <nav aria-label="breadcrumb">
    <ol class="breadcrumb">
      <li class="breadcrumb-item active" aria-current="page"><%= @tweet.contents%>
      	 <p align="right">
      	  <a class="btn btn-dark" href="/tweet/<%=tweet.id%>/edit">수정</a>    
             <a data-confirm="트윗을 삭제하시겠습니까?" class="btn btn-danger" href="/tweet/<%=tweet.id%>/destroy">삭제</a>
      	 </p>
      </li>
    </ol>
  </nav>
  ```

  * `views/tweet/new.html.erb`

  ```html
  <form action ="/tweet/create" method="POST">
  	<input type="hidden" name="authenticity_token" value="<%=form_authenticity_token %>">
  	<input class="form-control" type="text" name="contents" placeholder="무슨 일이 일어나고 있나요?">
  	<input class="btn btn-info" type="submit" value="트윗">
  </form>
  ```

  * `views/tweet/edit.html.erb`

  ```html
  <form action="/tweet/<%=@tweet.id%>/update" method="POST">
  	 <input type="hidden" name="authenticity_token" value="<%=form_authenticity_token %>">
  	 <input class="form-control" type="text" name="contents" value="<%=@tweet.contents%>"><br><br>
  	 <input class ="btn btn-info" type= "submit" value="수정하기">
  </form>
  ```

  

* `config/routes.rb`

```
root 'tweet#index'

get '/tweet' => 'tweet#index'
get '/tweet/new' => 'tweet#new'
post '/tweet/create' => 'tweet#create'
get '/tweet/:id/destroy' => 'tweet#destroy'
get '/tweet/:id/edit' => 'tweet#edit'
post '/tweet/:id/update' => 'tweet#update'
get '/tweet/:id =>'ask#show'
```



* Bootstrap 적용하기

1-1

```
Gemfile
#Bootstrap
gem 'bootstrap','~>4.1.1'
$ bundle install
```

1-2`views/layouts/application.html.erb` : bootstrap코드 추가

```ruby
<!DOCTYPE html>
<html>
  <head>
    <title>TestApp</title>
    <%= csrf_meta_tags %>
    <meta name="viewport" content="width=device-width,initial-scale=1,shrink-to-fit=no">

    <%= stylesheet_link_tag    'application', media: 'all', 'data-turbolinks-track': 'reload' %>
    <%= javascript_include_tag 'application', 'data-turbolinks-track': 'reload' %>
  </head>
  
  <body>
  <div class="d-flex flex-column flex-md-row align-items-center p-3 px-md-4 mb-3 bg-white border-bottom box-shadow">
        <h5 class="my-0 mr-md-auto font-weight-normal">나에게 질문하기</h5>
        <nav class="my-2 my-md-0 mr-md-3">
          <a class="p-2 text-dark" href="/ask">홈으로</a>
          <a class="p-2 text-dark" href="/ask/new">질문하기</a>
        </nav>
  </div>

    <div class ="container">
      <%= yield %>
    </div>
  </body>
</html>

```

1-3`stylesheets/application.scss`

```ruby
@import "bootstrap";
```

1-4`javascripts/application.js `

```
//= require jquery
//= require jquery_ujs
//= require popper
//= require bootstrap
//= require turbolinks
//= require_tree .
```



* 작성한 사람의 ip주소 저장하기

* index에서는 contents 전체의 내용이 아닌 **앞에 10글자만 보여주기**

  * `app/assets/stylesheets/application.css`

  ```
  .etc {
      white-space: nowrap;
      overflow: hidden;
      text-overflow: ellipsis;
  }
  ```

  * 글자수 제한을 두고 싶은 곳에  "<div class="board_title>내용</div>"를 넣습니다. 

  ```
  <%=truncate( raw( sanitize(<%=tweet.contents%>, :tags => %w(table tr td), :attributes => %w(id class style) ) ), :length => 10, :omission => "..."), class: "etc") %>
  
  ```

* rails public image path : 이미지 저장은 public폴더에 

`<img src="/your_image_file_name.png"> `

* [ ] 다음주 월요일 : *ruby코드로 form 만들기=>view helper*