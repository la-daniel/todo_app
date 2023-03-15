import Toastify from 'toastify-js'

MessageToaster = {
  mounted() {
    this.handleEvent('toast', (payload) => {
      Toastify({
        text: payload.message,
        duration: 3000
        }).showToast();        
    })
  }
}
export default MessageToaster
