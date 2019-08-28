package com.example.demo;

import com.amazonaws.auth.profile.ProfileCredentialsProvider;
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.AmazonS3Client;
import com.amazonaws.services.s3.model.Bucket;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
public class DemoController {
    @GetMapping("/demo")
    public ResponseEntity<String> demo ()     {
        return new ResponseEntity("Demo", HttpStatus.OK);
    }

    @GetMapping("/s3List")
    public ResponseEntity<String> s3List ()     {
        String res = "";
//        AmazonS3 s3Client = new AmazonS3Client(new ProfileCredentialsProvider("default"));
        AmazonS3 s3Client = new AmazonS3Client();
        List<Bucket> buckets = s3Client.listBuckets();
        for ( Bucket bucket : buckets ) {
            res += bucket.getName() + " , ";
        }
        return new ResponseEntity(res, HttpStatus.OK);
    }

}
