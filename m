Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7C88C4332F
	for <linux-bcachefs@archiver.kernel.org>; Tue, 31 Oct 2023 14:45:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344319AbjJaOpC (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Tue, 31 Oct 2023 10:45:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344322AbjJaOpB (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Tue, 31 Oct 2023 10:45:01 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C1DBF3
        for <linux-bcachefs@vger.kernel.org>; Tue, 31 Oct 2023 07:44:59 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id d2e1a72fcca58-6b497c8575aso5829175b3a.1
        for <linux-bcachefs@vger.kernel.org>; Tue, 31 Oct 2023 07:44:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698763499; x=1699368299; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=EetBXtZyW8FVEtBCWZRtj4TB44aKOiUDq0aOKpj9kVU=;
        b=ZlizsIC7q80Mhbpq9WBXaKmc7nmoXiOdRaHBURniCgywn40eIIcuTp1jeM1jrj1bQW
         ZkCzrhqxgeVQNvmXJSwjcDytzqASSNs803Dar+dKgs3dt6I5QuYH58JaqJ/vEg63x0pU
         6WbGwtJUnQZNufVeggcr37deNsBcqppRQRe6rZ196YNehslnfkwk/e2VE6o9lIKhYHcC
         JP/CdXj5L5WSfJpc+t6CjwPyVEejqMCFpRo1m7qEZudX0XMlZxbCzZ0t4ZL3eEE2b3kk
         Afc3wAI1IyRMJRc3CRXsVTzLWXO20seFmZu5jYxCG1Fp335yWKmg5d2DB26P5GNO1ppQ
         5NvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698763499; x=1699368299;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EetBXtZyW8FVEtBCWZRtj4TB44aKOiUDq0aOKpj9kVU=;
        b=lYcUHcw1bFgItGHUElXZMlEP8ndcFEit9xAEeB1/VrUHG06w3/FvCv6/zmoDQnoLRi
         N44dtvqyHn6I4vqqvb+Kn3075m/mXNgwx/pD2wZs7NTSo8sXV7zEig3pwaR4L4S7O3UP
         97GfbewdPrLcgwF6nDEL5iEmhCcnDVD2OZiTLig82S2U6Yii0Hh3UbJEw5jyRo7naRY3
         lj7zPFd8QQXPYQ4hjo0+LNmhi34lCVv4iFgEYYoVMaHaovA4StNe33laFaRYFED5USh2
         z1A5iFCjT9C80h8d+koK14gedDeGSRpzwH/LMVm8pLWeMqwtWMm6YiGgTmv0jsKYib0W
         jxKA==
X-Gm-Message-State: AOJu0YxxpF0XDO7yISrfhxSN6nFj+9kyOcUhGdlZAtawvEWhCC7L9KM+
        ROoeLn3NSdFeQidpWHq3/Pw=
X-Google-Smtp-Source: AGHT+IH1YgzG/2te3j7ZX94VPb/ryG2IFqoi94Cf+uGT6F0EQ/ChuhtHz3p4mxLVtzY3gTmTrre1BA==
X-Received: by 2002:a05:6a00:1a4e:b0:690:1c1b:aefd with SMTP id h14-20020a056a001a4e00b006901c1baefdmr15525335pfv.5.1698763498659;
        Tue, 31 Oct 2023 07:44:58 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id m19-20020aa79013000000b006c0fdb87b8fsm1331069pfo.61.2023.10.31.07.44.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Oct 2023 07:44:57 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <49228447-6d01-434f-8b8b-b0308d2cfeb5@roeck-us.net>
Date:   Tue, 31 Oct 2023 07:44:56 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: odebuf and lockdep splat with bcachefs
Content-Language: en-US
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-bcachefs@vger.kernel.org,
        Kent Overstreet <kent.overstreet@linux.dev>
References: <09a4c8ed-c984-4582-b5c4-0804ee4d55ec@roeck-us.net>
 <ZUELDel5DKZGfAwu@bfoster>
From:   Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 mDW4+i+XlNFUPUYMrIKi9joBhu18ssf5i5Q=
In-Reply-To: <ZUELDel5DKZGfAwu@bfoster>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On 10/31/23 07:11, Brian Foster wrote:
> On Mon, Oct 30, 2023 at 08:07:17PM -0700, Guenter Roeck wrote:
>> Hi,
>>
>> when trying the new bcachefs in the mainline kernel, I see the
>> attached ODEBUG and lockdep splats.
>>
>> This is simply mounting an empty bcachefs file system and
>> copying some files into it.
>>
> 
> Hi Guenter,
> 
> I reproduce fairly quickly with DEBUG_OBJECTS_WORK enabled. It looks to
> me that the lockdep splat is essentially fallout from the subsequent
> warning, which doesn't like the INIT_WORK() of the onstack rhashtable.
> Ideally this could INIT_WORK_ONSTACK(), but I don't see support for that
> plumbed through the rhashtable interface. Given this is the main copygc
> task fn, it seems fairly reasonable to me to just slab alloc the whole
> bucket tracking structure (as below). This addresses the splat for me on
> a quick test.
> 

The patch below fixes the problem for me.

Tested-by: Guenter Roeck <linux@roeck-us.net>

Tested with arm64 qemu, both little and big endian.

Thanks,
Guenter

> Kent,
> 
> Let me know if you're good with this and I'll post a proper patch..
> 
> Brian
> 
> --- 8< ---
> 
> diff --git a/fs/bcachefs/movinggc.c b/fs/bcachefs/movinggc.c
> index 4017120baeee..b835b85ef8b9 100644
> --- a/fs/bcachefs/movinggc.c
> +++ b/fs/bcachefs/movinggc.c
> @@ -304,14 +304,16 @@ static int bch2_copygc_thread(void *arg)
>   	struct moving_context ctxt;
>   	struct bch_move_stats move_stats;
>   	struct io_clock *clock = &c->io_clock[WRITE];
> -	struct buckets_in_flight buckets;
> +	struct buckets_in_flight *buckets;
>   	u64 last, wait;
>   	int ret = 0;
>   
> -	memset(&buckets, 0, sizeof(buckets));
> -
> -	ret = rhashtable_init(&buckets.table, &bch_move_bucket_params);
> +	buckets = kzalloc(sizeof(struct buckets_in_flight), GFP_KERNEL);
> +	if (!buckets)
> +		return -ENOMEM;
> +	ret = rhashtable_init(&buckets->table, &bch_move_bucket_params);
>   	if (ret) {
> +		kfree(buckets);
>   		bch_err_msg(c, ret, "allocating copygc buckets in flight");
>   		return ret;
>   	}
> @@ -329,12 +331,12 @@ static int bch2_copygc_thread(void *arg)
>   		cond_resched();
>   
>   		if (!c->copy_gc_enabled) {
> -			move_buckets_wait(trans, &ctxt, &buckets, true);
> +			move_buckets_wait(trans, &ctxt, buckets, true);
>   			kthread_wait_freezable(c->copy_gc_enabled);
>   		}
>   
>   		if (unlikely(freezing(current))) {
> -			move_buckets_wait(trans, &ctxt, &buckets, true);
> +			move_buckets_wait(trans, &ctxt, buckets, true);
>   			__refrigerator(false);
>   			continue;
>   		}
> @@ -345,7 +347,7 @@ static int bch2_copygc_thread(void *arg)
>   		if (wait > clock->max_slop) {
>   			c->copygc_wait_at = last;
>   			c->copygc_wait = last + wait;
> -			move_buckets_wait(trans, &ctxt, &buckets, true);
> +			move_buckets_wait(trans, &ctxt, buckets, true);
>   			trace_and_count(c, copygc_wait, c, wait, last + wait);
>   			bch2_kthread_io_clock_wait(clock, last + wait,
>   					MAX_SCHEDULE_TIMEOUT);
> @@ -355,14 +357,16 @@ static int bch2_copygc_thread(void *arg)
>   		c->copygc_wait = 0;
>   
>   		c->copygc_running = true;
> -		ret = bch2_copygc(trans, &ctxt, &buckets);
> +		ret = bch2_copygc(trans, &ctxt, buckets);
>   		c->copygc_running = false;
>   
>   		wake_up(&c->copygc_running_wq);
>   	}
>   
> -	move_buckets_wait(trans, &ctxt, &buckets, true);
> -	rhashtable_destroy(&buckets.table);
> +	move_buckets_wait(trans, &ctxt, buckets, true);
> +
> +	rhashtable_destroy(&buckets->table);
> +	kfree(buckets);
>   	bch2_trans_put(trans);
>   	bch2_moving_ctxt_exit(&ctxt);
> 

