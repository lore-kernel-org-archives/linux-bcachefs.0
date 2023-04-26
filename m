Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47247C7618E
	for <linux-bcachefs@archiver.kernel.org>; Wed, 26 Apr 2023 14:42:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241451AbjDZOmV (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Wed, 26 Apr 2023 10:42:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241276AbjDZOmU (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Wed, 26 Apr 2023 10:42:20 -0400
X-Greylist: delayed 83428 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 26 Apr 2023 07:42:19 PDT
Received: from out-12.mta1.migadu.com (out-12.mta1.migadu.com [IPv6:2001:41d0:203:375::c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CA072703
        for <linux-bcachefs@vger.kernel.org>; Wed, 26 Apr 2023 07:42:18 -0700 (PDT)
Date:   Wed, 26 Apr 2023 10:42:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1682520137;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3QzWdyskdwx/Z8JGYNQPpCk4aoKGVR8e1O/5vETl7Yw=;
        b=b7ZvwWSV+CfL8AN3OX0WVakbGQobhlUDxpSehexqKNnCkmJ5tg7SzykIaHKj2OhfaUbljS
        K5NGhTBD7dT+B3KRNvYyQ9AtVXs4qqb7I9faVa9WkHTFxsCRTGi7Zsc9Nyx6HkVOavVpuJ
        O3QsUF+siYecV/tqIdljDuupQPH/4G0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Janpieter Sollie <janpieter.sollie@kabelmail.de>
Cc:     linux-bcachefs@vger.kernel.org,
        Janpieter Sollie <janpieter.sollie@edpnet.be>
Subject: Re: [PATCH] add --data_types for bcachefs device add
Message-ID: <ZEk4RA1Vwy8ua3JP@moria.home.lan>
References: <20230426072858.7236-1-janpieter.sollie@kabelmail.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230426072858.7236-1-janpieter.sollie@kabelmail.de>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Wed, Apr 26, 2023 at 09:28:58AM +0200, Janpieter Sollie wrote:
> From: Janpieter Sollie <janpieter.sollie@edpnet.be>
> 
> bcachefs format allows to specify data types allowed on a specific device
> but this currently is not available when adding a device with bcachefs format.
> The patch adds this functionality.  It is kept as minimal as possible,
> in the future the device specific OPTS from cmd_format should be imported
> instead of specifying them a 2nd time here
> 
> Signed-off-by: Janpieter Sollie <janpieter.sollie@kabelmail.de>
> ---
>  cmd_device.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/cmd_device.c b/cmd_device.c
> index c59d370..2da9b87 100644
> --- a/cmd_device.c
> +++ b/cmd_device.c
> @@ -51,6 +51,7 @@ static void device_add_usage(void)
>  	     "  -B, --bucket=size           Bucket size\n"
>  	     "  -D, --discard               Enable discards\n"
>  	     "  -l, --label=label           Disk label\n"
> +	     "  -a, --data_allowed=types    allowed data on this device\n"
>  	     "  -f, --force                 Use device even if it appears to already be formatted\n"
>  	     "  -h, --help                  Display this help and exit\n"
>  	     "\n"
> @@ -64,6 +65,7 @@ int cmd_device_add(int argc, char *argv[])
>  		{ "bucket",		required_argument,	NULL, 'B' },
>  		{ "discard",		no_argument,		NULL, 'D' },
>  		{ "label",		required_argument,	NULL, 'l' },
> +		{ "data_allowed",	required_argument,	NULL, 'a' },
>  		{ "force",		no_argument,		NULL, 'f' },
>  		{ "help",		no_argument,		NULL, 'h' },
>  		{ NULL }
> @@ -90,6 +92,10 @@ int cmd_device_add(int argc, char *argv[])
>  		case 'l':
>  			dev_opts.label = strdup(optarg);
>  			break;

Wtf!?!?!?

> +                case 'a':
> +                        dev_opts.data_allowed = bch2_read_flag_list(optarg, bch2_data_types);
> +                        if(dev_opts.data_allowed == (u64) -1) die("invalid data_allowed types for device - aborting");
> +                        break;
>  		case 'f':
>  			force = true;
>  			break;
> -- 
> 2.39.1
> 
