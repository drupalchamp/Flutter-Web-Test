import 'package:flutter/material.dart';

List<JobDetails> _searchResult = [];
List<JobDetails> _jobDetails = [];

class JobDetails {
  //final String jobId, title, companyName, location, via, description, extensions;
  final String jobId, title, companyName, location, via, description;

  //JobDetails({this.jobId, this.title, this.companyName, this.location, this.via, this.description, this.extensions});
  JobDetails({this.jobId, this.title, this.companyName, this.location, this.via, this.description});

  factory JobDetails.fromJson(Map<String, dynamic> json) {
    return new JobDetails(
      jobId: json['job_id'],
      title: json['title'],
      companyName: json['company_name'],
      location: json['location'],
      via: json['via'],
      description: json['description'],
      //extensions: json['extensions'],
    );
  }
}