class MessagesController < ApplicationController
  def index
    # Message.index(message_params)
    # Messegeモデルのインスタンス情報を代入
    @message = Message.new
    # Room.find(params[:room_id])とすることでparamsに含まれているroom_idを代入
    @room =Room.find(params[:room_id])
    # チャットルームに紐づいている全てのメッセージ(@room.messages)を@mesagesと定義
    @messages = @room.messages.includes(:user)
    # includesメソッドでN＋1問題を解消
  end

  def create
    @room = Room.find(params[:room_id])
    # @room.messages.newでチャットルームに紐づいたメッセージのインスタンスを生成。
    # message_paramsを引数にしてprivateメソッドを呼び出す。その値を@messageに代入。
    @message = @room.messages.new(message_params)
    # saveメソッドでメッセージの内容をmessagesテーブルに保存
    if @message.save
      redirect_to room_messages_path (@room)
      # messagesコントローラーのindexアクションに再度リクエストを送信し、新たにインスタンス変数を生成
    else
      @messages = @room.messages.includes(:user)
      # includesメソッドでN＋1問題を解消

      render :index
      # indexアクションのインスタンス変数はそのままindex.html.erbに渡され、同じページに戻る。
    end
  end

  # プライベートメソッドとしてcontentをメッセージテーブルへ保存できるようにする
  private
  def message_params
    params.require(:message).permit(:content, :image).merge(user_id: current_user.id)
    # パラメーターの中にログインしているユーザーのidと紐づいているcontentを受け取れるように許可している

  end
end
