
import UIKit
import Firebase

class UploadViewController: UIViewController, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate{

    
    @IBOutlet weak var previewImage: UIImageView!
    @IBOutlet weak var postBtn: UIButton!
    @IBOutlet weak var selectBtn: UIButton!
    @IBOutlet var descriptions: UITextField!
    @IBOutlet var titles: UITextField!
    @IBOutlet var location: UIPickerView!
    @IBOutlet var language: UIPickerView!
    let picker = UIImagePickerController()
    
    var locations = ["NYC", "San Francisco","Boston","DC"]
    var languages = ["Arabic","French","English","Spanish"]
    var locationPick = ""
    var languagePick = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()

        picker.delegate = self
        location.delegate = self
        location.dataSource = self
        language.delegate = self
        language.dataSource = self
        picker.delegate=self
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == location{
            locationPick = locations[row]
            return locationPick
        }
        else{
            languagePick = languages[row]
            return languages[row]
        }
        
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == language {
            return languages.count
        }
            
        else{
            return locations.count
        }
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.previewImage.image = image
            selectBtn.isHidden = true
            postBtn.isHidden = false
        }
        
        self.dismiss(animated: true, completion: nil)
    }

    
    @IBAction func selectPressed(_ sender: Any) {
        
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        
        self.present(picker, animated: true, completion: nil)
        
    }
    
    
    @IBAction func postPressed(_ sender: Any) {
        AppDelegate.instance().showActivityIndicator()
        
        let uid = FIRAuth.auth()!.currentUser!.uid
        let ref = FIRDatabase.database().reference()
        let storage = FIRStorage.storage().reference(forURL: "gs://saathi2-7ed87.appspot.com")
        let key = ref.child("posts").childByAutoId().key
        let imageRef = storage.child("posts").child(uid).child("\(key).jpg")
        
        let data = UIImageJPEGRepresentation(self.previewImage.image!, 0.6)
        
        let uploadTask = imageRef.put(data!, metadata: nil) { (metadata, error) in
            if error != nil {
                print(error!.localizedDescription)
                AppDelegate.instance().dismissActivityIndicatos()
                return
            }
            
            imageRef.downloadURL(completion: { (url, error) in
                if let url = url {
                    let feed = ["userID" : uid,
                                "pathToImage" : url.absoluteString,
                                "likes" : 0,
                                "titles": self.titles.text!,
                                "descriptions":self.descriptions.text!,
                                "languages":self.languagePick,
                                "locations":self.locationPick,
                                "author" : FIRAuth.auth()!.currentUser!.displayName!,
                                "postID" : key] as [String : Any]
                    
                    let postFeed = ["\(key)" : feed]
                    
                    ref.child("posts").updateChildValues(postFeed)
                    AppDelegate.instance().dismissActivityIndicatos()
                    
                    self.dismiss(animated: true, completion: nil)
                }
            })
        
        }
        
        uploadTask.resume()
        
    }
    
}
