class BooksController < ApplicationController
  before_action :authenticate_user!

  def search
    num = params[:num]
    @search = Book.search(params[:search], (num))
  end

  def fabo
    @book = Book.find(params[:id])
  end

  def new
    @book = Book.new
  end

  def create
     @book = Book.new(book_params)
     @book.user_id = current_user.id
   respond_to do |format|
    if @book.save
      flash[:notice] = "successfully"
      format.html { redirect_to @user }
      format.json { render :index, status: :created, location: @user }
      format.js { @status = "success"}
    else
      @books = Book.all
      @user = current_user
      format.html { render :index }
      format.json { render :index, status: :unprocessable_entity }
      format.js { @status = "fail" }
      # render action: :index
     end
    end
   end

  def index
     @books = Book.all.order(id:'DESC')
     @book = Book.new
     @user = current_user
  end

  def show
    @books = Book.new
    @book = Book.find(params[:id])
    @user = @book.user
    @book_comment = BookComment.new
  end

  def edit
    @book = Book.find(params[:id])
    unless current_user == @book.user
      redirect_to books_path
  end
end

  def update
    @book = Book.find(params[:id])
 if @book.update(book_params)
    flash[:notice] = "successfully"
    redirect_to book_path(@book)
  else
    render action: :edit
   end
  end

  def destroy
    @book = Book.find(params[:id])
    unless current_user == @book.user
      redirect_to books_path
else
    @book.destroy
    flash[:notice] = "successfully"
    redirect_to books_path
  end
 end

  private
  def book_params
    params.require(:book).permit(:title, :body)
  end

end
