let CanTrack = artifacts.require('./CanTrack.sol');

contract('CanTrack', accounts => {

    let owner = accounts[0];
    let url = 'https:\/\/canya-tracker.firebaseapp.com/';
    let data = JSON.stringify({"id":"CANTRACK","globalTimer":{"counter":{"isOn":false,"isLocalTimer":false,"prev":57000,"days":0,"hours":0,"minutes":0,"seconds":57,"ranges":[]},"createdAt":"2018-3-28","dates":{"2018-3-28":[{"hour":"6am","display":true,"width":"4.166666666666667%","ranges":[{"width":"7.777777777777778%","color":"#4EDCCA","taskId":0,"diff":"0.5 mins"},{"width":"4.166666666666667%","color":"#0078BF","taskId":1,"diff":"0.3 mins"},{"width":"5.277777777777778%","color":"#FF6666","taskId":2,"diff":"0.3 mins"}]},{"hour":"7am","display":true,"width":"4.166666666666667%","ranges":[{"width":"2.7777777777777777%","color":"#4EDCCA","taskId":0,"diff":"0.2 mins"},{"width":"4.166666666666667%","color":"#0078BF","taskId":1,"diff":"0.3 mins"},{"width":"2.7777777777777777%","color":"#0078BF","taskId":5,"diff":"0.2 mins"},{"width":"3.055555555555556%","color":"#FF6666","taskId":4,"diff":"0.2 mins"}]}]}},"taskList":{"0":{"id":0,"description":"Send contract to the client","time":38000,"color":"#4EDCCA","ranges":[{"from":"2018-03-28T06:52:16-06:00","to":"2018-03-28T06:52:44-06:00"},{"from":"2018-03-28T07:04:40-06:00","to":"2018-03-28T07:04:50-06:00"}]},"1":{"id":1,"description":"Ask for company assets","time":30000,"color":"#0078BF","ranges":[{"from":"2018-03-28T06:53:23-06:00","to":"2018-03-28T06:53:38-06:00"},{"from":"2018-03-28T07:05:18-06:00","to":"2018-03-28T07:05:33-06:00"}]},"2":{"id":2,"description":"Setup a tribe for the project","time":19000,"color":"#FF6666","ranges":[{"from":"2018-03-28T06:55:16-06:00","to":"2018-03-28T06:55:35-06:00"}]},"4":{"id":4,"description":"Create GIT repo","time":10000,"color":"#FF6666","ranges":[{"from":"2018-03-28T07:07:09-06:00","to":"2018-03-28T07:07:20-06:00"}]},"5":{"id":5,"description":"Another task...","time":9000,"color":"#0078BF","ranges":[{"from":"2018-03-28T07:06:49-06:00","to":"2018-03-28T07:06:59-06:00"}]}}});

    let ShortLinkEvent;
    let shortLinkCode;

    CanTrack.deployed().then(instance => {
        ShortLinkEvent = instance.ShortLink({});
        ShortLinkEvent.watch((error, result) => {
            if (error) {
                console.log(error);
            }
            
            let pieces = result.args.code.split('/');
            shortLinkCode = pieces[pieces.length-1];
        });
    });

    it('should have preset variables on contract creation', () => {
        let cantrack;
        
        return CanTrack.deployed().then(instance => {
            cantrack = instance;
            return instance.getURL();
        }).then(url => {
            assert.equal(url.valueOf(), url, 'url does not match url');
            return cantrack.owner.call();
        }).then(creator => {
            assert.equal(creator.valueOf(), owner, 'creator address does not match owner address');
        }).catch(error => console.log(error));
    });

    it('should add JSON data and generate shortlink', () => {
        let cantrack;
        let event;
        
        return CanTrack.deployed().then(instance => {
            cantrack = instance;
            return instance.addData(data);
        }).then(res => {
            return cantrack.getData(shortLinkCode);
        }).then(_data => {
            assert.equal(_data.valueOf(), data, 'data stored in the contract does not match initial data');
            return cantrack.getSender(shortLinkCode);
        }).then(sender => {
            assert.equal(sender.valueOf(), owner, 'the data sender does not match the contract caller address');
        }).catch(error => console.log(error));
    });
});



