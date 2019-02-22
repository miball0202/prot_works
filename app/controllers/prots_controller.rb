class ProtsController < ApplicationController
  before_action :set_prot, only: %i[show edit update destroy]
  before_action :authenticate_user!, except: %i[index]
  before_action :correct_user_check, only: %i[edit update destroy]
  before_action :private_prot_protect, only: %i[show edit update destroy]

  def index
    @prots = Prot.all.where(private: false).includes(:user)
  end

  def show
  end

  def new
    @prot = Prot.new
  end

  def create
    @prot = current_user.prots.new(prot_params)
    find_already_exist_for_genre
    if @prot.save
      # 要トランザクション
      @prot.nodes.create(title: "#{@prot.title}", body: "本文", position: 0)
      redirect_to @prot
      flash[:success] = "プロットの作成に成功しました"
    else
      render :new
    end
  end

  def edit
  end

  def update
    find_already_exist_for_genre
    if @prot.update(prot_params)
      redirect_to @prot
      flash[:success] = "プロットの編集に成功しました"
    else
      render :edit
    end
  end

  def destroy
    if params[:genre_id]
      @prot.prot_genres.find_by(genre_id: params[:genre_id]).destroy
      flash[:success] = 'ジャンルの削除に成功しました'
      redirect_to edit_prot_path
    else
      @prot.destroy
      flash[:success] = 'プロットの削除に成功しました'
      redirect_to root_path
    end
  end

  private

  def prot_params
    params.require(:prot)
          .permit(:title,
                  :content,
                  :private,
                  :accepts_review)
  end

  def correct_user_check
    raise StandardError if @prot.user_id != current_user.id
  end

  def private_prot_protect
    raise StandardError if @prot.private == true && @prot.user_id != current_user.id
  end

  def set_prot
    @prot = Prot.find(params[:id])
  end

  def find_already_exist_for_genre
    if params[:genre_name]
      if already_genre = Genre.find_by(name: params[:prot][:genre_name])
        @prot.prot_genres.build(genre_id: already_genre.id)
      else
        @prot.genres.build(name: params[:prot][:genre_name])
      end
    else
      params.delete(:genre_name)
    end
  end
end
