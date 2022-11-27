export default interface IReply {
  errorFound: boolean;
  messageInfo: any;
  success: boolean;
  rowAffect?: number;
  data?: Array<any>
  logout: boolean
}
export const defaultReply = {
  errorFound: false,
  messageInfo: '',
  success: false,
  rowAffect: 0,
  data: [],
  logout: true
}
