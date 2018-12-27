import web3 from './web3';
import Trivia from './build/Trivia.json';

export default address => {
  return new web3.eth.Contract(JSON.parse(Trivia.interface), address);
};