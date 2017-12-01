//
//  ViewController.swift
//  Roomie
//
//  Created by Vivek Tallavajhala  on 10/25/17.
//  Copyright © 2017 Monsters Inc. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import FirebaseAuth
import Firebase
import FirebaseDatabase

class ChatViewController: JSQMessagesViewController {

    var messages = [JSQMessage]() //array of JSQMessage items to store the messages in the chat
    
    /*!
     * @discussion Sets outgoing message bubble colors to blue
     * @param None
     * @return Blue bubbles
     */
    lazy var outgoingBubble: JSQMessagesBubbleImage = {
        return JSQMessagesBubbleImageFactory()!.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
    }()
    
    /*!
     * @discussion Sets incoming message bubble colors to red
     * @param None
     * @return red bubbles
     */
    lazy var incomingBubble: JSQMessagesBubbleImage = {
        return JSQMessagesBubbleImageFactory()!.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleRed())
    }()
    
    /*!
     * @discussion Override load function for chat view
     * @param None
     * @return Chat view displayed and user created
     */
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        let defaults = UserDefaults.standard //sets to temporary constant
        let user = Auth.auth().currentUser;
        
        
        /*
        if let id = user?.uid,
            let name = user?.displayName
        {
        
        senderId = id
        senderDisplayName = name
        }
        else
        {
            senderId = user?.uid
            senderDisplayName = ""
            showDisplayNameDialog()
            
        }
 */
        
        if  let id = user?.uid, //check if jsq_id exist in user defaults
            let name = defaults.string(forKey: "jsq_name") //check if jsq_name exist in user defaults
        {
            senderId = id //assign to id if exists
            senderDisplayName = name //assign to name if exists
        }
        else
        {
            senderId = user?.uid //String(arc4random_uniform(999999)) //assign random string to sender_id (each user will need a random and different sender id)
            senderDisplayName = "" //assign empty string to display name
            
            defaults.set(senderId, forKey: "jsq_id") //save new senderID in user defaults for key jsq_id
            defaults.synchronize() //saves user defaults
            
            showDisplayNameDialog() //show display name
        }
        
        title = "Chat: \(senderDisplayName!)" //changes view controller title to Chat: [display name]
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showDisplayNameDialog)) //lets user change displayname by clicking on navigation bar
        tapGesture.numberOfTapsRequired = 1
        
        navigationController?.navigationBar.addGestureRecognizer(tapGesture)
        
        
        inputToolbar.contentView.leftBarButtonItem = nil //hides the attachment button on the left of the chat text input field.
        collectionView.collectionViewLayout.incomingAvatarViewSize = CGSize.zero //hides avatar for incoming view message by setting equal to 0
        collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero //hides avatar for outgoing view message by setting equal to 0
        
        let query = Constants.refs.databaseChats.queryLimited(toLast: 10) //prepares a query from firebase
        
        _ = query.observe(.childAdded, with: { [weak self] snapshot in //observes query for changes
            
            if  let data        = snapshot.value as? [String: String], //uses optional binding to unwrap and cast snapshot to a dictionary of strings
                let id          = data["sender_id"], //assigns ID constant in dictionary
                let name        = data["name"], //assigns name constant in dictionary
                let text        = data["text"], //assigns text constant in dictionary
                !text.isEmpty //makes sure no empty text bubbles show in UI
            {
                if let message = JSQMessage(senderId: id, displayName: name, text: text)
                {
                    self?.messages.append(message) //incoming message appended to messages array
                    
                    self?.finishReceivingMessage() //prompts JSQMVC to refresh UI and show new message
                }
            }
        })
    }

    /*!
     * @discussion Tells user to pick a displayname
     * @param None
     * @return User ID is changed to user input
     */
    @objc func showDisplayNameDialog()
    {
        let defaults = UserDefaults.standard
        //var user = Auth.auth().currentUser;
        
        let alert = UIAlertController(title: "Display Name", message: "Choose a display name to begin chatting. Others will see this name when you send chat messages. You can change your display name again by tapping the navigation bar.", preferredStyle: .alert) //tells user to pick displayname
        
        alert.addTextField { textField in
            
            if let name = defaults.string(forKey: "jsq_name")
            {
                textField.text = name //sets name to what user chose
            }
            else
            {
                let names = ["Display Name"]
                textField.text = names[Int(arc4random_uniform(UInt32(names.count)))] //sets name if user doesn't pick
            }
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self, weak alert] _ in
            
            if let textField = alert?.textFields?[0], !textField.text!.isEmpty {
                
                self?.senderDisplayName = textField.text
                
                self?.title = "Chat: \(self!.senderDisplayName!)"
                
                defaults.set(textField.text, forKey: "jsq_name")
                defaults.synchronize()
            }
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    /*!
     * @discussion Displays various messages from users
     * @param Messages view
     * @return An item from messages based on the index from indexPath.item. This will return the message data for a particular message by its index.
     */
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData!
    {
        return messages[indexPath.item]
    }
    
    /*!
     * @discussion Displays collection view of all messages
     * @param UI view
     * @return the total number of messages, based on messages.count – the amount of items in the array
     */
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return messages.count
    }
    
    /*!
     * @discussion Dispose of any resources that can be recreated.
     * @param None
     * @return Memory warning notification
     */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    /*!
     * @discussion Configure JSQ for incoming / outgoing messages
     * @param Messages collection view
     * @return Messages in view
     */
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource!
    {
        return messages[indexPath.item].senderId == senderId ? outgoingBubble : incomingBubble
    }
    
    /*!
     * @discussion This will hide the avatars for message bubbles
     * @param Messages view
     * @return nil when JSQMVC wants avatar image data
     */
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource!
    {
        return nil
    }

    /*!
     * @discussion called when label text is needed
     * @param Messages view
     * @return label text
     */
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAt indexPath: IndexPath!) -> NSAttributedString!
    {
        return messages[indexPath.item].senderId == senderId ? nil : NSAttributedString(string: messages[indexPath.item].senderDisplayName)
    }
    
    /*!
     * @discussion called when height of top label is needed
     * @param Collection view
     * @return Sets height of top label
     */
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAt indexPath: IndexPath!) -> CGFloat
    {
        return messages[indexPath.item].senderId == senderId ? 0 : 15
    }
    
    /*!
     * @discussion Allows user to send message to group
     * @param button object, sender Id, display name, date
     * @return Stores value in firebase database
     */
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!)
    {
        let ref = Constants.refs.databaseChats.childByAutoId() //create reference to new value in Firebase on /chats node
        
        let message = ["sender_id": senderId, "name": senderDisplayName, "text": text] //dictionary that contains all information about to-be sent message - sender ID, name, chat text
        
        ref.setValue(message) //store dictionary in node
        
        finishSendingMessage() //tells JSQMVC that we are done
    }
    
}

