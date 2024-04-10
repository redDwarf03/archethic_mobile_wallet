var background;(()=>{"use strict";class e{extensionPortResolvers=new Map;getPair(e){const n=this.extensionPortResolvers.get(e);if(void 0!==n)return n;const t=new o;return this.extensionPortResolvers.set(e,t),t}release(e){this.extensionPortResolvers.delete(e)}}class o{#e=null;#o;onBothEndClosed=()=>{};constructor(){this.#o=new n,this.#o.onDisconnect=()=>{this._dispatchStatusEvent()}}get extensionPortResolver(){return this.#o}get webpagePort(){return this.#e}set webpagePort(e){this.#e=e,this._dispatchStatusEvent()}_dispatchStatusEvent(){null!==this.#e||this.#o.isExtensionAlive||this.onBothEndClosed()}}class n{#n=null;#t=null;#s=[];onDisconnect=()=>{};onReady=()=>{};onMessage=e=>{};get isExtensionAlive(){return null!==this.#t}constructor(){chrome.runtime.onConnect.addListener((async e=>{if(null===this.#n){console.log("Extension popup connected"),this.#n=e,this.onReady();for(const e of this.#s)console.log("Resolving callback"),e(this.#n);this.#s=[],console.log("Callbacks resolving done"),this.#n.onMessage.addListener((e=>{this.onMessage(e)})),this.#n.onDisconnect.addListener((()=>{console.log("Extension popup disconnected"),this.#n=null,this.onDisconnect()})),console.log("Extension popup ready")}}))}get port(){return this.#n}waitForConnection(e){return null!==this.#n?(console.log("Extension popup ready"),void e(this.#n)):(this.#s.push(e),null!==this.#t?(console.log("Extension popup already exists."),void chrome.windows.update(this.#t.id,{focused:!0})):(console.log("Opening extension popup"),chrome.windows.create({url:"index.html",width:370,height:800,type:"panel",focused:!0}).then((e=>{this.#t=e})),void chrome.windows.onRemoved.addListener((e=>{console.log("Extension popup closed"),this.#t?.id===e&&(this.#t=null)}))))}}(new class{run(){const o=new e;chrome.runtime.onConnectExternal.addListener((async e=>{console.log("Webpage connected ");const n=e.sender?.origin;if(void 0===n)return void console.warn("Webpage port without origin → Ignoring connection.");const t=o.getPair(n);t.webpagePort=e,t.onBothEndClosed=()=>{console.log(`Connexion released ${n}`),o.release(n)},e.onDisconnect.addListener((e=>{console.log(`WebPage disconnected ${n}`),t.webpagePort=null})),t.extensionPortResolver.onMessage=o=>{console.log(`Extension response received ${o}`),e.postMessage(o)},e.onMessage.addListener((e=>{console.log(`Webpage message received : ${e} from ${n}`),t.extensionPortResolver.waitForConnection((o=>{o.postMessage(e)}))}))}))}}).run(),background={}})();
//# sourceMappingURL=data:application/json;charset=utf-8;base64,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LEtBQUssc0RBSWpCLE1BQU1DLEVBQVdOLEVBQVc3QyxRQUFRZ0QsR0FDcENHLEVBQVNuQyxZQUFjK0IsRUFFdkJJLEVBQVN4QyxnQkFBa0IsS0FDdkJnQixRQUFRQyxJQUFJLHNCQUFzQm9CLEtBQ2xDSCxFQUFXcEMsUUFBUXVDLEVBQU8sRUFHOUJELEVBQVlqQyxhQUFhVyxhQUFhMkIsSUFDbEN6QixRQUFRQyxJQUFJLHdCQUF3Qm9CLEtBQ3BDRyxFQUFTbkMsWUFBYyxJQUFJLElBRy9CbUMsRUFBU2pELHNCQUFzQmtCLFVBQWFDLElBQ3hDTSxRQUFRQyxJQUFJLCtCQUErQlAsS0FDM0MwQixFQUFZTSxZQUFZaEMsRUFBUSxFQUdwQzBCLEVBQVkzQixVQUFVSyxhQUFhSixJQUMvQk0sUUFBUUMsSUFBSSw4QkFBOEJQLFVBQWdCMkIsS0FDMURHLEVBQVNqRCxzQkFBc0I0QixtQkFBbUJiLElBQzlDQSxFQUFLb0MsWUFBWWhDLEVBQVEsR0FDM0IsR0FDSixHQUdWLElBMklBdUIsTSIsInNvdXJjZXMiOlsid2VicGFjazovL3dlYi1jaHJvbWUtZXh0ZW5zaW9uLy4vc3JjL2JhY2tncm91bmQudHMiXSwic291cmNlc0NvbnRlbnQiOlsiY2xhc3MgQVdTIHtcbiAgICBydW4oKSB7XG4gICAgICAgIGNvbnN0IHBvcnRzUGFpcnMgPSBuZXcgUG9ydHNQYWlyc01hcCgpXG4gICAgICAgIGNocm9tZS5ydW50aW1lLm9uQ29ubmVjdEV4dGVybmFsLmFkZExpc3RlbmVyKGFzeW5jICh3ZWJQYWdlUG9ydCkgPT4ge1xuICAgICAgICAgICAgY29uc29sZS5sb2coYFdlYnBhZ2UgY29ubmVjdGVkIGApXG5cbiAgICAgICAgICAgIGNvbnN0IG9yaWdpbiA9IHdlYlBhZ2VQb3J0LnNlbmRlcj8ub3JpZ2luXG5cbiAgICAgICAgICAgIGlmIChvcmlnaW4gPT09IHVuZGVmaW5lZCkge1xuICAgICAgICAgICAgICAgIGNvbnNvbGUud2FybihgV2VicGFnZSBwb3J0IHdpdGhvdXQgb3JpZ2luIOKGkiBJZ25vcmluZyBjb25uZWN0aW9uLmApXG4gICAgICAgICAgICAgICAgcmV0dXJuXG4gICAgICAgICAgICB9XG5cbiAgICAgICAgICAgIGNvbnN0IHBvcnRQYWlyID0gcG9ydHNQYWlycy5nZXRQYWlyKG9yaWdpbilcbiAgICAgICAgICAgIHBvcnRQYWlyLndlYnBhZ2VQb3J0ID0gd2ViUGFnZVBvcnRcblxuICAgICAgICAgICAgcG9ydFBhaXIub25Cb3RoRW5kQ2xvc2VkID0gKCkgPT4ge1xuICAgICAgICAgICAgICAgIGNvbnNvbGUubG9nKGBDb25uZXhpb24gcmVsZWFzZWQgJHtvcmlnaW59YClcbiAgICAgICAgICAgICAgICBwb3J0c1BhaXJzLnJlbGVhc2Uob3JpZ2luKVxuICAgICAgICAgICAgfVxuXG4gICAgICAgICAgICB3ZWJQYWdlUG9ydC5vbkRpc2Nvbm5lY3QuYWRkTGlzdGVuZXIoKF8pID0+IHtcbiAgICAgICAgICAgICAgICBjb25zb2xlLmxvZyhgV2ViUGFnZSBkaXNjb25uZWN0ZWQgJHtvcmlnaW59YClcbiAgICAgICAgICAgICAgICBwb3J0UGFpci53ZWJwYWdlUG9ydCA9IG51bGxcbiAgICAgICAgICAgIH0pXG5cbiAgICAgICAgICAgIHBvcnRQYWlyLmV4dGVuc2lvblBvcnRSZXNvbHZlci5vbk1lc3NhZ2UgPSAobWVzc2FnZSkgPT4ge1xuICAgICAgICAgICAgICAgIGNvbnNvbGUubG9nKGBFeHRlbnNpb24gcmVzcG9uc2UgcmVjZWl2ZWQgJHttZXNzYWdlfWApXG4gICAgICAgICAgICAgICAgd2ViUGFnZVBvcnQucG9zdE1lc3NhZ2UobWVzc2FnZSlcbiAgICAgICAgICAgIH1cblxuICAgICAgICAgICAgd2ViUGFnZVBvcnQub25NZXNzYWdlLmFkZExpc3RlbmVyKChtZXNzYWdlKSA9PiB7XG4gICAgICAgICAgICAgICAgY29uc29sZS5sb2coYFdlYnBhZ2UgbWVzc2FnZSByZWNlaXZlZCA6ICR7bWVzc2FnZX0gZnJvbSAke29yaWdpbn1gKVxuICAgICAgICAgICAgICAgIHBvcnRQYWlyLmV4dGVuc2lvblBvcnRSZXNvbHZlci53YWl0Rm9yQ29ubmVjdGlvbigocG9ydCkgPT4ge1xuICAgICAgICAgICAgICAgICAgICBwb3J0LnBvc3RNZXNzYWdlKG1lc3NhZ2UpXG4gICAgICAgICAgICAgICAgfSlcbiAgICAgICAgICAgIH0pXG4gICAgICAgIH0pXG5cbiAgICB9XG59XG5cbmNsYXNzIFBvcnRzUGFpcnNNYXAge1xuICAgIGV4dGVuc2lvblBvcnRSZXNvbHZlcnM6IE1hcDxzdHJpbmcsIFBvcnRQYWlyPiA9IG5ldyBNYXAoKVxuXG4gICAgZ2V0UGFpcihpZDogc3RyaW5nKTogUG9ydFBhaXIge1xuICAgICAgICBjb25zdCBleHRlbnNpb25Qb3J0UmVzb2x2ZXIgPSB0aGlzLmV4dGVuc2lvblBvcnRSZXNvbHZlcnMuZ2V0KGlkKVxuICAgICAgICBpZiAoZXh0ZW5zaW9uUG9ydFJlc29sdmVyICE9PSB1bmRlZmluZWQpIHJldHVybiBleHRlbnNpb25Qb3J0UmVzb2x2ZXJcblxuICAgICAgICBjb25zdCBuZXdQb3J0UGFpciA9IG5ldyBQb3J0UGFpcigpXG5cbiAgICAgICAgdGhpcy5leHRlbnNpb25Qb3J0UmVzb2x2ZXJzLnNldChpZCwgbmV3UG9ydFBhaXIpXG4gICAgICAgIHJldHVybiBuZXdQb3J0UGFpclxuICAgIH1cblxuICAgIHJlbGVhc2UoaWQ6IHN0cmluZykge1xuICAgICAgICB0aGlzLmV4dGVuc2lvblBvcnRSZXNvbHZlcnMuZGVsZXRlKGlkKVxuICAgIH1cbn1cblxuXG5jbGFzcyBQb3J0UGFpciB7XG4gICAgI3dlYnBhZ2VQb3J0OiBjaHJvbWUucnVudGltZS5Qb3J0IHwgbnVsbCA9IG51bGxcbiAgICAjZXh0ZW5zaW9uUG9ydFJlc29sdmVyOiBFeHRlbnNpb25Qb3J0UmVzb2x2ZXJcblxuICAgIG9uQm90aEVuZENsb3NlZCA9ICgpID0+IHsgfVxuXG4gICAgY29uc3RydWN0b3IoKSB7XG4gICAgICAgIHRoaXMuI2V4dGVuc2lvblBvcnRSZXNvbHZlciA9IG5ldyBFeHRlbnNpb25Qb3J0UmVzb2x2ZXIoKVxuICAgICAgICB0aGlzLiNleHRlbnNpb25Qb3J0UmVzb2x2ZXIub25EaXNjb25uZWN0ID0gKCkgPT4ge1xuICAgICAgICAgICAgdGhpcy5fZGlzcGF0Y2hTdGF0dXNFdmVudCgpXG4gICAgICAgIH1cbiAgICB9XG5cbiAgICBnZXQgZXh0ZW5zaW9uUG9ydFJlc29sdmVyKCk6IEV4dGVuc2lvblBvcnRSZXNvbHZlciB7XG4gICAgICAgIHJldHVybiB0aGlzLiNleHRlbnNpb25Qb3J0UmVzb2x2ZXJcbiAgICB9XG5cbiAgICBnZXQgd2VicGFnZVBvcnQoKTogY2hyb21lLnJ1bnRpbWUuUG9ydCB8IG51bGwge1xuICAgICAgICByZXR1cm4gdGhpcy4jd2VicGFnZVBvcnRcbiAgICB9XG5cbiAgICBzZXQgd2VicGFnZVBvcnQocG9ydDogY2hyb21lLnJ1bnRpbWUuUG9ydCB8IG51bGwpIHtcbiAgICAgICAgdGhpcy4jd2VicGFnZVBvcnQgPSBwb3J0O1xuICAgICAgICB0aGlzLl9kaXNwYXRjaFN0YXR1c0V2ZW50KClcbiAgICB9XG5cbiAgICBfZGlzcGF0Y2hTdGF0dXNFdmVudCgpIHtcbiAgICAgICAgaWYgKHRoaXMuI3dlYnBhZ2VQb3J0ID09PSBudWxsICYmICF0aGlzLiNleHRlbnNpb25Qb3J0UmVzb2x2ZXIuaXNFeHRlbnNpb25BbGl2ZSkge1xuICAgICAgICAgICAgdGhpcy5vbkJvdGhFbmRDbG9zZWQoKTtcbiAgICAgICAgfVxuICAgIH1cblxufVxuXG5cbmNsYXNzIEV4dGVuc2lvblBvcnRSZXNvbHZlciB7XG4gICAgI2V4dGVuc2lvblBvcHVwUG9ydDogY2hyb21lLnJ1bnRpbWUuUG9ydCB8IG51bGwgPSBudWxsXG4gICAgI2V4dGVuc2lvbldpbmRvdzogY2hyb21lLndpbmRvd3MuV2luZG93IHwgbnVsbCA9IG51bGxcbiAgICAjY2FsbGJhY2tzV2FpdGluZ0ZvckNvbm5lY3Rpb246IEFycmF5PChwb3J0OiBjaHJvbWUucnVudGltZS5Qb3J0KSA9PiB1bmRlZmluZWQ+ID0gW11cblxuICAgIG9uRGlzY29ubmVjdCA9ICgpID0+IHsgfVxuICAgIG9uUmVhZHkgPSAoKSA9PiB7IH1cbiAgICBvbk1lc3NhZ2UgPSAobWVzc2FnZTogYW55KSA9PiB7IH1cblxuICAgIGdldCBpc0V4dGVuc2lvbkFsaXZlKCkge1xuICAgICAgICByZXR1cm4gdGhpcy4jZXh0ZW5zaW9uV2luZG93ICE9PSBudWxsXG4gICAgfVxuXG4gICAgY29uc3RydWN0b3IoKSB7XG4gICAgICAgIGNocm9tZS5ydW50aW1lLm9uQ29ubmVjdC5hZGRMaXN0ZW5lcihhc3luYyAocG9ydCkgPT4ge1xuICAgICAgICAgICAgaWYgKHRoaXMuI2V4dGVuc2lvblBvcHVwUG9ydCAhPT0gbnVsbCkgcmV0dXJuO1xuXG4gICAgICAgICAgICBjb25zb2xlLmxvZygnRXh0ZW5zaW9uIHBvcHVwIGNvbm5lY3RlZCcpXG4gICAgICAgICAgICB0aGlzLiNleHRlbnNpb25Qb3B1cFBvcnQgPSBwb3J0XG5cbiAgICAgICAgICAgIHRoaXMub25SZWFkeSgpXG4gICAgICAgICAgICBmb3IgKGNvbnN0IGNhbGxiYWNrIG9mIHRoaXMuI2NhbGxiYWNrc1dhaXRpbmdGb3JDb25uZWN0aW9uKSB7XG4gICAgICAgICAgICAgICAgY29uc29sZS5sb2coJ1Jlc29sdmluZyBjYWxsYmFjaycpXG4gICAgICAgICAgICAgICAgY2FsbGJhY2sodGhpcy4jZXh0ZW5zaW9uUG9wdXBQb3J0KVxuICAgICAgICAgICAgfVxuICAgICAgICAgICAgdGhpcy4jY2FsbGJhY2tzV2FpdGluZ0ZvckNvbm5lY3Rpb24gPSBbXVxuICAgICAgICAgICAgY29uc29sZS5sb2coJ0NhbGxiYWNrcyByZXNvbHZpbmcgZG9uZScpXG5cbiAgICAgICAgICAgIHRoaXMuI2V4dGVuc2lvblBvcHVwUG9ydC5vbk1lc3NhZ2UuYWRkTGlzdGVuZXIoKG1lc3NhZ2UpID0+IHtcbiAgICAgICAgICAgICAgICB0aGlzLm9uTWVzc2FnZShtZXNzYWdlKVxuICAgICAgICAgICAgfSlcbiAgICAgICAgICAgIHRoaXMuI2V4dGVuc2lvblBvcHVwUG9ydC5vbkRpc2Nvbm5lY3QuYWRkTGlzdGVuZXIoKCkgPT4ge1xuICAgICAgICAgICAgICAgIGNvbnNvbGUubG9nKCdFeHRlbnNpb24gcG9wdXAgZGlzY29ubmVjdGVkJylcbiAgICAgICAgICAgICAgICB0aGlzLiNleHRlbnNpb25Qb3B1cFBvcnQgPSBudWxsXG4gICAgICAgICAgICAgICAgdGhpcy5vbkRpc2Nvbm5lY3QoKVxuICAgICAgICAgICAgfSlcbiAgICAgICAgICAgIGNvbnNvbGUubG9nKCdFeHRlbnNpb24gcG9wdXAgcmVhZHknKVxuICAgICAgICB9KVxuICAgIH1cblxuICAgIGdldCBwb3J0KCk6IGNocm9tZS5ydW50aW1lLlBvcnQgfCBudWxsIHtcbiAgICAgICAgcmV0dXJuIHRoaXMuI2V4dGVuc2lvblBvcHVwUG9ydFxuICAgIH1cblxuICAgIHdhaXRGb3JDb25uZWN0aW9uKGNhbGxiYWNrOiAocG9ydDogY2hyb21lLnJ1bnRpbWUuUG9ydCkgPT4gdW5kZWZpbmVkKSB7XG4gICAgICAgIGlmICh0aGlzLiNleHRlbnNpb25Qb3B1cFBvcnQgIT09IG51bGwpIHtcbiAgICAgICAgICAgIGNvbnNvbGUubG9nKCdFeHRlbnNpb24gcG9wdXAgcmVhZHknKVxuICAgICAgICAgICAgY2FsbGJhY2sodGhpcy4jZXh0ZW5zaW9uUG9wdXBQb3J0KVxuICAgICAgICAgICAgcmV0dXJuXG4gICAgICAgIH1cblxuICAgICAgICB0aGlzLiNjYWxsYmFja3NXYWl0aW5nRm9yQ29ubmVjdGlvbi5wdXNoKGNhbGxiYWNrKVxuXG4gICAgICAgIGlmICh0aGlzLiNleHRlbnNpb25XaW5kb3cgIT09IG51bGwpIHtcbiAgICAgICAgICAgIGNvbnNvbGUubG9nKCdFeHRlbnNpb24gcG9wdXAgYWxyZWFkeSBleGlzdHMuJylcbiAgICAgICAgICAgIGNocm9tZS53aW5kb3dzLnVwZGF0ZShcbiAgICAgICAgICAgICAgICB0aGlzLiNleHRlbnNpb25XaW5kb3cuaWQhLFxuICAgICAgICAgICAgICAgIHsgZm9jdXNlZDogdHJ1ZSB9LFxuICAgICAgICAgICAgKVxuICAgICAgICAgICAgcmV0dXJuXG4gICAgICAgIH1cblxuICAgICAgICBjb25zb2xlLmxvZygnT3BlbmluZyBleHRlbnNpb24gcG9wdXAnKVxuXG4gICAgICAgIGNocm9tZS53aW5kb3dzLmNyZWF0ZSh7XG4gICAgICAgICAgICB1cmw6IFwiaW5kZXguaHRtbFwiLFxuICAgICAgICAgICAgd2lkdGg6IDM3MCxcbiAgICAgICAgICAgIGhlaWdodDogODAwLFxuICAgICAgICAgICAgdHlwZTogXCJwYW5lbFwiLFxuICAgICAgICAgICAgZm9jdXNlZDogdHJ1ZSxcbiAgICAgICAgfSkudGhlbigod2luZG93KSA9PiB7XG4gICAgICAgICAgICB0aGlzLiNleHRlbnNpb25XaW5kb3cgPSB3aW5kb3dcbiAgICAgICAgfSk7XG4gICAgICAgIGNocm9tZS53aW5kb3dzLm9uUmVtb3ZlZC5hZGRMaXN0ZW5lcigod2luZG93SWQpID0+IHtcbiAgICAgICAgICAgIGNvbnNvbGUubG9nKCdFeHRlbnNpb24gcG9wdXAgY2xvc2VkJylcbiAgICAgICAgICAgIGlmICh0aGlzLiNleHRlbnNpb25XaW5kb3c/LmlkID09PSB3aW5kb3dJZCkge1xuICAgICAgICAgICAgICAgIHRoaXMuI2V4dGVuc2lvbldpbmRvdyA9IG51bGw7XG4gICAgICAgICAgICB9XG4gICAgICAgIH0pXG4gICAgfVxufVxuY29uc3QgYXdzID0gbmV3IEFXUygpXG5hd3MucnVuKClcbiJdLCJuYW1lcyI6WyJQb3J0c1BhaXJzTWFwIiwiZXh0ZW5zaW9uUG9ydFJlc29sdmVycyIsIk1hcCIsImdldFBhaXIiLCJpZCIsImV4dGVuc2lvblBvcnRSZXNvbHZlciIsInRoaXMiLCJnZXQiLCJ1bmRlZmluZWQiLCJuZXdQb3J0UGFpciIsIlBvcnRQYWlyIiwic2V0IiwicmVsZWFzZSIsImRlbGV0ZSIsIm9uQm90aEVuZENsb3NlZCIsImNvbnN0cnVjdG9yIiwiRXh0ZW5zaW9uUG9ydFJlc29sdmVyIiwib25EaXNjb25uZWN0IiwiX2Rpc3BhdGNoU3RhdHVzRXZlbnQiLCJ3ZWJwYWdlUG9ydCIsInBvcnQiLCJpc0V4dGVuc2lvbkFsaXZlIiwib25SZWFkeSIsIm9uTWVzc2FnZSIsIm1lc3NhZ2UiLCJjaHJvbWUiLCJydW50aW1lIiwib25Db25uZWN0IiwiYWRkTGlzdGVuZXIiLCJhc3luYyIsImNvbnNvbGUiLCJsb2ciLCJjYWxsYmFjayIsIndhaXRGb3JDb25uZWN0aW9uIiwicHVzaCIsIndpbmRvd3MiLCJ1cGRhdGUiLCJmb2N1c2VkIiwiY3JlYXRlIiwidXJsIiwid2lkdGgiLCJoZWlnaHQiLCJ0eXBlIiwidGhlbiIsIndpbmRvdyIsIm9uUmVtb3ZlZCIsIndpbmRvd0lkIiwicnVuIiwicG9ydHNQYWlycyIsIm9uQ29ubmVjdEV4dGVybmFsIiwid2ViUGFnZVBvcnQiLCJvcmlnaW4iLCJzZW5kZXIiLCJ3YXJuIiwicG9ydFBhaXIiLCJfIiwicG9zdE1lc3NhZ2UiXSwic291cmNlUm9vdCI6IiJ9