Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2ED3C77B61
	for <linux-bcachefs@archiver.kernel.org>; Thu, 27 Apr 2023 04:21:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240740AbjD0EVu (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Thu, 27 Apr 2023 00:21:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbjD0EVs (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Thu, 27 Apr 2023 00:21:48 -0400
Received: from relay-b01.edpnet.be (relay-b01.edpnet.be [212.71.1.221])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F6022D69
        for <linux-bcachefs@vger.kernel.org>; Wed, 26 Apr 2023 21:21:46 -0700 (PDT)
X-ASG-Debug-ID: 1682569303-15c4346fe479d4f0001-qsCQDO
Received: from [192.168.177.53] (213.219.188.14.adsl.dyn.edpnet.net [213.219.188.14]) by relay-b01.edpnet.be with ESMTP id ctIG0MUEGewFQyuf; Thu, 27 Apr 2023 06:21:43 +0200 (CEST)
X-Barracuda-Envelope-From: janpieter.sollie@kabelmail.de
X-Barracuda-Effective-Source-IP: 213.219.188.14.adsl.dyn.edpnet.net[213.219.188.14]
X-Barracuda-Apparent-Source-IP: 213.219.188.14
Message-ID: <a90787ac-4db0-4cfb-879d-a7d2879a8296@kabelmail.de>
Date:   Thu, 27 Apr 2023 06:21:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH] add --data_types for bcachefs device add
Content-Language: en-US, nl-BE
X-ASG-Orig-Subj: Re: [PATCH] add --data_types for bcachefs device add
To:     Kent Overstreet <kent.overstreet@linux.dev>
Cc:     linux-bcachefs@vger.kernel.org,
        Janpieter Sollie <janpieter.sollie@edpnet.be>
References: <20230426072858.7236-1-janpieter.sollie@kabelmail.de>
 <ZEk4RA1Vwy8ua3JP@moria.home.lan>
From:   Janpieter Sollie <janpieter.sollie@kabelmail.de>
In-Reply-To: <ZEk4RA1Vwy8ua3JP@moria.home.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Barracuda-Connect: 213.219.188.14.adsl.dyn.edpnet.net[213.219.188.14]
X-Barracuda-Start-Time: 1682569303
X-Barracuda-URL: https://212.71.1.221:443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at edpnet.be
X-Barracuda-Scan-Msg-Size: 2584
X-Barracuda-BRTS-Status: 1
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=7.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.107985
        Rule breakdown below
         pts rule name              description
        ---- ---------------------- --------------------------------------------------
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Op 26/04/2023 om 16:42 schreef Kent Overstreet:
> On Wed, Apr 26, 2023 at 09:28:58AM +0200, Janpieter Sollie wrote:
>> From: Janpieter Sollie <janpieter.sollie@edpnet.be>
>>
>> bcachefs format allows to specify data types allowed on a specific device
>> but this currently is not available when adding a device with bcachefs format.
>> The patch adds this functionality.  It is kept as minimal as possible,
>> in the future the device specific OPTS from cmd_format should be imported
>> instead of specifying them a 2nd time here
>>
>> Signed-off-by: Janpieter Sollie <janpieter.sollie@kabelmail.de>
>> ---
>>   cmd_device.c | 6 ++++++
>>   1 file changed, 6 insertions(+)
>>
>> diff --git a/cmd_device.c b/cmd_device.c
>> index c59d370..2da9b87 100644
>> --- a/cmd_device.c
>> +++ b/cmd_device.c
>> @@ -51,6 +51,7 @@ static void device_add_usage(void)
>>   	     "  -B, --bucket=size           Bucket size\n"
>>   	     "  -D, --discard               Enable discards\n"
>>   	     "  -l, --label=label           Disk label\n"
>> +	     "  -a, --data_allowed=types    allowed data on this device\n"
>>   	     "  -f, --force                 Use device even if it appears to already be formatted\n"
>>   	     "  -h, --help                  Display this help and exit\n"
>>   	     "\n"
>> @@ -64,6 +65,7 @@ int cmd_device_add(int argc, char *argv[])
>>   		{ "bucket",		required_argument,	NULL, 'B' },
>>   		{ "discard",		no_argument,		NULL, 'D' },
>>   		{ "label",		required_argument,	NULL, 'l' },
>> +		{ "data_allowed",	required_argument,	NULL, 'a' },
>>   		{ "force",		no_argument,		NULL, 'f' },
>>   		{ "help",		no_argument,		NULL, 'h' },
>>   		{ NULL }
>> @@ -90,6 +92,10 @@ int cmd_device_add(int argc, char *argv[])
>>   		case 'l':
>>   			dev_opts.label = strdup(optarg);
>>   			break;
> Wtf!?!?!?
>
>> +                case 'a':
>> +                        dev_opts.data_allowed = bch2_read_flag_list(optarg, bch2_data_types);
>> +                        if(dev_opts.data_allowed == (u64) -1) die("invalid data_allowed types for device - aborting");
>> +                        break;
>>   		case 'f':
>>   			force = true;
>>   			break;
>> -- 
>> 2.39.1
>>

I know you said it would be better to move the read_flag_list_or_die() function to a shared library,
but as I said, this is a minimal version,
when I figure out a proper way to share OPTS,
it will revert to using  read_flag_list_or_die().
For now, I thought not moving too much is the best thing while analyzing the situation for a 
clean solution
