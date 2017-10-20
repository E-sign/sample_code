require 'httparty'
require 'base64'
require 'pry'

base_uri = 'http://esign.dev/api'
auth_token = "##################"
options = {
  'Content-Type': 'application/json'
}

############
# send an original doc
############
options[:body] = {
  "base64_title": "original file",
  "base64_ext": "pdf",
  "base64_doc": Base64.encode64(File.open(Dir.pwd + '/file/pdf-sample.pdf').read)
}
result = HTTParty.post("#{base_uri}/original_files?auth_token=#{auth_token}", options)
original_doc = JSON.parse(result.body)

# {
#    "success":true,
#    "src":"https://esign-development.s3-eu-west-1.amazonaws.com/uploads/original_file/file/000/092/439/original_file.pdf?X-Amz-Expires=600&X-Amz-Date=20171019T145929Z&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAJLGLLV6CP7FXUFRA/20171019/eu-west-1/s3/aws4_request&X-Amz-SignedHeaders=host&X-Amz-Signature=1b41a74dd52efd3eac5132ab89779226ba21ef0032d148fbc3f2c34404d3b9bf",
#    "file":{
#       "id":"y8E236mktJGTXKQiUji-ONBD4og5Uw",  <<============ original file ID
#       "date":"2017-10-19T15:59:29.047+01:00",
#       "processing":true,
#       "filename":"original_file.pdf",
#       "file_size":"15672",
#       "author":{
#          "name":"Chris Ward",
#          "email":"cw6365@googlemail.com"
#       },
#       "url":"https://esign-development.s3-eu-west-1.amazonaws.com/uploads/original_file/file/000/092/439/original_file.pdf?X-Amz-Expires=600&X-Amz-Date=20171019T145929Z&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAJLGLLV6CP7FXUFRA/20171019/eu-west-1/s3/aws4_request&X-Amz-SignedHeaders=host&X-Amz-Signature=1b41a74dd52efd3eac5132ab89779226ba21ef0032d148fbc3f2c34404d3b9bf",
#       "href":"http://esign.dev/api/original_files/y8E236mktJGTXKQiUji-ONBD4og5Uw"
#    }
# }



##############
# Create a document for signing
#
# Using the returned original file ID we create a document ready for signing.
# This duplicates the original file and creates a new document ready to be edited.
#
##############
options[:body] = {
  "documents": [
     {
        "title": "Example document one",
        "file": {
          "id": "#{original_doc["file"]["id"]}"
        },
        "signers": [
          {
            "name": "Tom Jones",
            "email": "tom@example.com"
         },
         {
           "name": "John Doe",
           "email": "john@example.com"
         }
       ],
       "stop_api_email": true
    },
    {
       "title": "Example document two",
       "file": {
         "id": "#{original_doc["file"]["id"]}"
       },
       "signers": [
         {
           "name": "Tom Jones",
           "email": "tom@example.com"
        },
        {
          "name": "John Doe",
          "email": "john@example.com"
        }
      ],
      "stop_api_email": true
   }
  ]
}
result = HTTParty.post("#{base_uri}/documents?auth_token=#{auth_token}", options)
document_pack = JSON.parse(result.body)

# {
#    "title":"Example document one",
#    "description":"",
#    "status":"Pending",
#    "last_interaction":"2017-10-19T16:19:35.672+01:00",
#    "attachment_files":[
#
#    ],
#    "signers":[
#       {
#          "name":"Tom Jones",
#          "email_address":"tom@example.com",
#          "last_viewed":null,
#          "amount_viewed":0,
#          "response_ip":null,
#          "response_os":null,
#          "response_browser":null,
#          "response_browser_version":null,
#          "passport_check":null,
#          "driving_licence_check":null,
#          "utility_bill_check":null,
#          "verification_check":null,
#          "signed_at":null,
#          "verified":false,
#          "required_additional_fields":[
#
#          ],
#          "document_id":"0eQqL6syEBv52PRem600v0WjxsAzvQ",
#          "id":"secAhIY0ERNP4LCnri-Wg1izsdl0ew", <<========== SIGNER'S ID
#          "status":"Pending",
#          "current":false,
#          "synchronous_current":false,
#          "registered":false,
#          "aml_document":null,
#          "placeholder":false,
#          "custom_signature":false
#       },
#       {
#          "name":"John Doe",
#          "email_address":"john@example.com",
#          "last_viewed":null,
#          "amount_viewed":0,
#          "response_ip":null,
#          "response_os":null,
#          "response_browser":null,
#          "response_browser_version":null,
#          "passport_check":null,
#          "driving_licence_check":null,
#          "utility_bill_check":null,
#          "verification_check":null,
#          "signed_at":null,
#          "verified":false,
#          "required_additional_fields":[
#
#          ],
#          "document_id":"0eQqL6syEBv52PRem600v0WjxsAzvQ",
#          "id":"26XCTUT6mTNCUjPHHAt4RFuP5jl-Sw",
#          "status":"Pending",
#          "current":false,
#          "synchronous_current":false,
#          "registered":false,
#          "aml_document":null,
#          "placeholder":false,
#          "custom_signature":false
#       }
#    ],
#    "labels":[
#
#    ],
#    "multiple_documents":[
#       {
#          "title":"Example document two",
#          "status":"Pending",
#          "signers":[
#             {
#                "name":"Tom Jones",
#                "email_address":"tom@example.com",
#                "last_viewed":null,
#                "amount_viewed":0,
#                "response_ip":null,
#                "response_os":null,
#                "response_browser":null,
#                "response_browser_version":null,
#                "passport_check":null,
#                "driving_licence_check":null,
#                "utility_bill_check":null,
#                "verification_check":null,
#                "signed_at":null,
#                "verified":false,
#                "required_additional_fields":[
#
#                ],
#                "document_id":"59hdygmkvVYFv5wI2fjQ9vPtYH58Rw",
#                "id":"frXZXU6700E2MVj2tjVbvFAoZh57lg",
#                "status":"Pending",
#                "current":false,
#                "synchronous_current":false,
#                "registered":false,
#                "aml_document":null,
#                "placeholder":false,
#                "custom_signature":false
#             },
#             {
#                "name":"John Doe",
#                "email_address":"john@example.com",
#                "last_viewed":null,
#                "amount_viewed":0,
#                "response_ip":null,
#                "response_os":null,
#                "response_browser":null,
#                "response_browser_version":null,
#                "passport_check":null,
#                "driving_licence_check":null,
#                "utility_bill_check":null,
#                "verification_check":null,
#                "signed_at":null,
#                "verified":false,
#                "required_additional_fields":[
#
#                ],
#                "document_id":"59hdygmkvVYFv5wI2fjQ9vPtYH58Rw",
#                "id":"Stk_x5kNvdSbJs-0NfP_UomShHhf9Q",
#                "status":"Pending",
#                "current":false,
#                "synchronous_current":false,
#                "registered":false,
#                "aml_document":null,
#                "placeholder":false,
#                "custom_signature":false
#             }
#          ],
#          "id":"59hdygmkvVYFv5wI2fjQ9vPtYH58Rw" <<===== THIS IS THE DOCUMENT ID OF THE OTHER MULTIPLE DOCUMENTS
#       }
#    ],
#    "id":"0eQqL6syEBv52PRem600v0WjxsAzvQ", <<===== THIS IS THE DOCUMENT ID OF THE MASTER DOCUMENT
#    "synchronous":false,
#    "date":"2017-10-19T16:19:35.672+01:00",
#    "is_master":true,
#    "parent":null,
#    "href":"http://esign.dev/api/documents/0eQqL6syEBv52PRem600v0WjxsAzvQ",
#    "signed_file":{
#       "url":null
#    },
#    "original_file":{
#       "id":"y8E236mktJGTXKQiUji-ONBD4og5Uw",
#       "url":"https://esign-development.s3-eu-west-1.amazonaws.com/uploads/original_file/file/000/092/439/original_file.pdf?X-Amz-Expires=600&X-Amz-Date=20171019T151935Z&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAJLGLLV6CP7FXUFRA/20171019/eu-west-1/s3/aws4_request&X-Amz-SignedHeaders=host&X-Amz-Signature=8458cb3be3b81b26e02160e2105efdb60192687e4499c47ab2f849e3f6288d20",
#       "filename":"original_file.pdf",
#       "processing":null
#    },
#    "images":[
#       {
#          "url":"https://esign-development.s3-eu-west-1.amazonaws.com/uploads/document_image/001/466/354/y8E236mktJGTXKQiUji-ONBD4og5Uw_1.png?X-Amz-Expires=600&X-Amz-Date=20171019T151935Z&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAJLGLLV6CP7FXUFRA/20171019/eu-west-1/s3/aws4_request&X-Amz-SignedHeaders=host&X-Amz-Signature=76f988e48bf6bc8003139fd4ca7a22d1e346e0bfcf7e57f8437126efc9d1ddc3"
#       }
#    ],
#    "author":{
#       "current":true,
#       "shared":true,
#       "name":"Chris Ward",
#       "email":"cw6365@googlemail.com"
#    },
#    "signer_id":null,
#    "additional_info":null,
#    "document_meta":{
#       "document_file_pages":null,
#       "original_file_pages":1,
#       "appended_signature":null
#    }
# }

#==================
#
# NOTE: The response above returns the ID of the newly created documents. The first
# (and master) document's id is within the top level as pointed out above. Any other multiple documents
# can be found in the `multiple_documents` array. The document id and signer id's are also repeated
# in the signers array.
#
# These are the ids that are used from now on. The Original File ID only points to the original file
# which never changes. All changes (eg. status) are found by querying each document's id.
#
#==================



##############
# Signing the document
#
# Using document id and the signers id we can sign the file.
#
##############
options[:body] = {
  "agreed": true,
  "system": {
     "os": "Mac",
     "browser": "Chrome",
     "browser_version": 39
   }
}
signers = document_pack["signers"] + document_pack["multiple_documents"][0]["signers"]

signers.each do |signer|
  HTTParty.put("#{base_uri}/signers/#{signer["id"]}", options)
end


##############
# Checking the document status
##############
result = HTTParty.get("#{base_uri}/documents/#{document_pack["id"]}")
document = JSON.parse(result)

# document["status"]=>"Signed"
# document["signers"][0]["status"] =>"Signed"
