Return-Path: <linux-bcachefs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6F29C433EF
	for <linux-bcachefs@archiver.kernel.org>; Sun,  8 May 2022 07:41:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230054AbiEHHpg (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Sun, 8 May 2022 03:45:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229756AbiEHHpf (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Sun, 8 May 2022 03:45:35 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4DB3655E
        for <linux-bcachefs@vger.kernel.org>; Sun,  8 May 2022 00:41:45 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 58CB61F8F5;
        Sun,  8 May 2022 07:41:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1651995704; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FqjTOJHgK3tzzoISMkG4Kk8SCY0JjT7h/OB+PyDwfAk=;
        b=V5hiUA8LqHmPdTfD0+fKxKxDDA49rMSjMAL76Xsz62cOQhbF4I2NE9V65ZD+xopp7WTG35
        N1hLLhmD6mnJRZtPXejhD+knshSMa6feAt8AXZ9Fgz5m5YavPd9ZJqRg7eC5I152/8daXN
        AtTqsnFsSuzJJuXBAf4ou90TXBXc1eE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1651995704;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FqjTOJHgK3tzzoISMkG4Kk8SCY0JjT7h/OB+PyDwfAk=;
        b=Qb4mDYM6jNoflpSAOX5MlbCCvRo5g2TFRkkrlmscHwSy1DYf/3YSUQG9XgmpzU0r+LGPKA
        cJq8FT54WUj/4pCA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 5AE3C13A97;
        Sun,  8 May 2022 07:41:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id Y9FiCzd0d2J3dgAAMHmgww
        (envelope-from <colyli@suse.de>); Sun, 08 May 2022 07:41:43 +0000
Message-ID: <9772af22-d081-1a52-93a1-5be732b8c710@suse.de>
Date:   Sun, 8 May 2022 15:41:41 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.1
Subject: Re: bug in bcachefs -> bio_copy_data_iter
Content-Language: en-US
To:     Kent Overstreet <kent.overstreet@gmail.com>,
        Christoph Hellwig <hch@lst.de>
Cc:     ming.lei@redhat.com, linux-bcachefs@vger.kernel.org
References: <YYrwbksSPdtITbEs@moria.home.lan>
 <84ff96fe-ff4b-b58b-b732-88e87fe0b502@suse.de>
 <20220423173123.GA29024@lst.de>
 <20220507182841.erbdexnphra2f3iz@moria.home.lan>
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20220507182841.erbdexnphra2f3iz@moria.home.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On 5/8/22 2:28 AM, Kent Overstreet wrote:
> On Sat, Apr 23, 2022 at 07:31:23PM +0200, Christoph Hellwig wrote:
>> On Wed, Nov 10, 2021 at 08:02:06PM +0800, Coly Li wrote:
>>>> looks like it should be functionally equivalent), but clearly I'm missing
>>>> something... wonder if there might be some relation to the bug you guys hit in
>>>> bcache with bvec_virt.
>>>>
>>>> Any ideas?
>>> I experience similar one in bcache code during my recent development,
>> Can you try this patch?
> Coly, did you look at this?
>
> Christoph, the fix looks correct to me - let's get it in if you haven't sent it
> to Jens yet.
>

Hi Kent and Christoph,


I tried it and trying it still. Without this change, I don't observe 
immediate panic in 5.18-rcX, so applying it I don't see obvious 
different, just testing it with my current development patches.

It's fine to have it in mainline IMHO.


Coly Li


>> diff --git a/block/bio.c b/block/bio.c
>> index 4259125e16ab2..ac29c87c6735c 100644
>> --- a/block/bio.c
>> +++ b/block/bio.c
>> @@ -1336,10 +1336,12 @@ void bio_copy_data_iter(struct bio *dst, struct bvec_iter *dst_iter,
>>   		struct bio_vec src_bv = bio_iter_iovec(src, *src_iter);
>>   		struct bio_vec dst_bv = bio_iter_iovec(dst, *dst_iter);
>>   		unsigned int bytes = min(src_bv.bv_len, dst_bv.bv_len);
>> -		void *src_buf;
>> +		void *src_buf = bvec_kmap_local(&src_bv);
>> +		void *dst_buf = bvec_kmap_local(&dst_bv);
>>   
>> -		src_buf = bvec_kmap_local(&src_bv);
>> -		memcpy_to_bvec(&dst_bv, src_buf);
>> +		memcpy(dst_buf, src_buf, bytes);
>> +
>> +		kunmap_local(dst_buf);
>>   		kunmap_local(src_buf);
>>   
>>   		bio_advance_iter_single(src, src_iter, bytes);


