Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4974C1FBF6E;
	Tue, 12 Nov 2024 15:08:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731424125; cv=none; b=W5i8p7ta+p9Ib8FwmehMQ3PqB4N1mLlTuWEehUzMA09+YQseNyfF79KvJEbEGEssxcHcb9H8NQUiYIWJL1LNrRBujpoVOMFFqEfX4s6Ds/6F7XZ+R7urpGrIjS+EnEVS4wnSATpZrnlkcuRVUrb2nmtWE+acJMjxPeueef7Qufo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731424125; c=relaxed/simple;
	bh=GkLVII9/KYA1hqUe4Drb/1cmWdjlUtsyeTwCgns9EY4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tzxrF7VO3OCUpVvUTC/QJ2wDZgwOy1rGAod5i+BA5kbRrLcaTS9XRZGdMuF6qSn/nx3Q8wJHX5sdO6AKsKmGOZdbYJoRbPuU4gQqP/fCW41HrH00oVeztQBps9fnG1a70ajsfZjVR1pgC0IEicqwl6G/gy9DWZSCtyUILQTdWj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=clfgnQ8u; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="clfgnQ8u"
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-a9ed49ec0f1so979214266b.1;
        Tue, 12 Nov 2024 07:08:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731424122; x=1732028922; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=t0mTrDwaf9phXosi5JIDFAL90E3bNC9+hiBItyZr/L8=;
        b=clfgnQ8uO8GdjMDVS327YSFR910sEAL8egr8BtzIMpYSNozn11mgVUaJDtwpvUcTuP
         Db9MH1dyMkWzZAC4fTk/iSxjzwznd0KfDwLbDwRR+JU2JgvBnzehrFf19TDFKVB+gSzh
         xIIfOs3DQwpRTTQ0R+fOkUkP8tMk2jqZRVhlFTRwd8ynBLWS5T0BJrvGKCFc9ZtICrV+
         EgNhyjfisRNx+bGMA5c4AzPHWB97ZSZbLyhHnHuUb+PX+t/w39anPVII6R3pIzorPABK
         +o4xlfHPXyAaIFC+ysJ5UJEB+/XL93H3AckMcgDnK2jX3eLHsWeFKaugAWBb87DZkysi
         tJ1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731424122; x=1732028922;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=t0mTrDwaf9phXosi5JIDFAL90E3bNC9+hiBItyZr/L8=;
        b=QilneYCJiNBPWO79mo+xv16/nbUA0+Erzpv95/1aDKJrEwbIz+ahVgiqAKEmMH7N7q
         yhME+id7BQzPET4BzRo7I2P297hR5Sux6j5p5UybBiM9T/xbf/wiRcRaX+liiTgarQGE
         UhOn2EP6xyBVz3/JRN9kDpTxFMiLrAS+3r2sygDXtDGCueeZv9ql1jVqphT0oxTu70Zu
         VGSFYK5LqVk7+OzMHYF4TMBvM61ycaOgrqlUtS3ZTtAn7M5BITEklujFXA38M2aLdN0W
         Qc6N0I9SIHRiTsD3pdvy/qsH4A7Cm29MCsuolszzfuSE4B72PeyOezGlWRciWbgKF+4p
         bxCQ==
X-Forwarded-Encrypted: i=1; AJvYcCVMhKu3UiaxUwe5El4av6+jqhjTDX1NssHGo4wIokboZf6VEOAwNS/GRQPPGFP/uz8B220phhFW2bwRhO0=@vger.kernel.org
X-Gm-Message-State: AOJu0YygieeRP+SJpNTVU+eJju6C/bzdUV5LTRSgV9Oq8EBktomO+Y9/
	H2XqiZuLu2ewNKow6fxan7/IUbJZmJaD+qXokthEkmKErcb2wjCq
X-Google-Smtp-Source: AGHT+IHju1WWZX4W4VIPf9BUon+BDSy4MXdNh2OlqhdeA+QbuEzDnuF6cdGWxRqWvpakLnGX1IGCNQ==
X-Received: by 2002:a17:907:3e0a:b0:a99:403e:2578 with SMTP id a640c23a62f3a-aa1b1024ddfmr311954066b.5.1731424121336;
        Tue, 12 Nov 2024 07:08:41 -0800 (PST)
Received: from ?IPV6:2a01:e11:5400:7400:e8e2:26d3:e800:6066? ([2a01:e11:5400:7400:e8e2:26d3:e800:6066])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9ee06b9d62sm724190966b.0.2024.11.12.07.08.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Nov 2024 07:08:40 -0800 (PST)
Message-ID: <382408d3-21ed-4bb3-87a2-60ad61583726@gmail.com>
Date: Tue, 12 Nov 2024 16:08:37 +0100
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] bcachefs: zero-init move_bucket struct in
 bch2_copygc_get_buckets()
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org,
 skhan@linuxfoundation.org,
 syzbot+8689d10f1894eedf774d@syzkaller.appspotmail.com
References: <20241111144242.757798-3-gianf.trad@gmail.com>
 <vtm2n2sjx4kpkx4slzpve6pv4lxhmotnvrhtqp2qobrmubvz35@s33ak2pst3h2>
From: Gianfranco Trad <gianf.trad@gmail.com>
Content-Language: en-US, it
Autocrypt: addr=gianf.trad@gmail.com; keydata=
 xjMEZyAY2RYJKwYBBAHaRw8BAQdA3W2zVEPRi03dmb95c7NkmFyBZi+VAplZZX9YVcsduG3N
 JkdpYW5mcmFuY28gVHJhZCA8Z2lhbmYudHJhZEBnbWFpbC5jb20+wo8EExYIADcWIQRJFQhW
 JFLZFapGQPDIleIjeBnIywUCZyAY2QUJA8JnAAIbAwQLCQgHBRUICQoLBRYCAwEAAAoJEMiV
 4iN4GcjL+JkA/RWGFWAqY06TH+ZZKuhNhvJhj2+dqgPF0QRjILpGSVJyAQCsvpKVS6H9ykYP
 Qyi/UyxIKxa8tcdSP1oUj9YIAHUcC844BGcgGNkSCisGAQQBl1UBBQEBB0BlosN6xF2pP/d7
 RVTlTFktASXfYhN0cghGG6dk5r47NgMBCAfCfgQYFggAJhYhBEkVCFYkUtkVqkZA8MiV4iN4
 GcjLBQJnIBjZBQkDwmcAAhsMAAoJEMiV4iN4GcjLuIIBAJBEkfB4sVF7T46JBpJBP5jBHm4B
 nmn274Qd7agQUZR4AQDfkC/p4qApuqZvZ3H0qOkexpf9swGV1UtmmzYQdmjyAw==
In-Reply-To: <vtm2n2sjx4kpkx4slzpve6pv4lxhmotnvrhtqp2qobrmubvz35@s33ak2pst3h2>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/11/24 21:09, Kent Overstreet wrote:
> On Mon, Nov 11, 2024 at 03:42:44PM +0100, Gianfranco Trad wrote:
>> zero-init move_bucket struct b fields in bch2_copygc_get_buckets()
>> to mitigate later uninit-value-use KMSAN reported bug.
>>
>> Reported-by: syzbot+8689d10f1894eedf774d@syzkaller.appspotmail.com
>> Closes: https://syzkaller.appspot.com/bug?extid=8689d10f1894eedf774d
>> Tested-by: syzbot+8689d10f1894eedf774d@syzkaller.appspotmail.com
>> Signed-off-by: Gianfranco Trad <gianf.trad@gmail.com>
>> ---
>>   fs/bcachefs/movinggc.c | 3 ++-
>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/bcachefs/movinggc.c b/fs/bcachefs/movinggc.c
>> index d658be90f737..cdc456b03bec 100644
>> --- a/fs/bcachefs/movinggc.c
>> +++ b/fs/bcachefs/movinggc.c
>> @@ -171,7 +171,8 @@ static int bch2_copygc_get_buckets(struct moving_context *ctxt,
>>   				  lru_pos(BCH_LRU_FRAGMENTATION_START, 0, 0),
>>   				  lru_pos(BCH_LRU_FRAGMENTATION_START, U64_MAX, LRU_TIME_MAX),
>>   				  0, k, ({
>> -		struct move_bucket b = { .k.bucket = u64_to_bucket(k.k->p.offset) };
>> +		struct move_bucket b = { 0 };
>> +		b.k.bucket = u64_to_bucket(k.k->p.offset);
>>   		int ret2 = 0;
> 
> Providing any sort of initializer should cause the whole struct to be
> initialized, are you and syzbot sure this is the right fix?
You are right, there's no need to initialize the whole struct.
I'm still in the process of fully understanding what reproducer is 
trying to do.
So far with the additional findings, b.k seems not to be initialized 
prior usage in repro case, therefore memset to 0 only the b.k field 
seems enough:

diff --git a/fs/bcachefs/movinggc.c b/fs/bcachefs/movinggc.c
index d658be90f737..515b05d26d11 100644
--- a/fs/bcachefs/movinggc.c
+++ b/fs/bcachefs/movinggc.c
@@ -171,7 +171,9 @@ static int bch2_copygc_get_buckets(struct 
moving_context *ctxt,
  				  lru_pos(BCH_LRU_FRAGMENTATION_START, 0, 0),
  				  lru_pos(BCH_LRU_FRAGMENTATION_START, U64_MAX, LRU_TIME_MAX),
  				  0, k, ({
-		struct move_bucket b = { .k.bucket = u64_to_bucket(k.k->p.offset) };
+		struct move_bucket b;
+		memset(&b.k, 0, sizeof(b.k));
+		b.k.bucket = u64_to_bucket(k.k->p.offset);
  		int ret2 = 0;

  		saw++;

The above patch was already tested-by syzbot[1].

Let me know if the patch looks good enough or if I should work on it more.

Thanks for your time,

[1] https://syzkaller.appspot.com/x/log.txt?x=1733b8c0580000

--Gian
