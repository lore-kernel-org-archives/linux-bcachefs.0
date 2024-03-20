Received: from mail-vk1-f179.google.com (mail-vk1-f179.google.com [209.85.221.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBF6E2CA6
	for <linux-bcachefs@vger.kernel.org>; Wed, 20 Mar 2024 21:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710971409; cv=none; b=hc0euz9sP18J0RiK95ve6Iir+4gf+WEtYZSR/M677k4hedfAihoBrn/N8SMWiF/eJQqg+ShkfdIBZYsIWAe0tYfT6RPMUQdB+/ydirJ7PdwrQN6i9xuJbaHy6a1v/JL5FmRbVpchU5A1/I8hMOJyjBCdnEzwY+FZnEO8j0I+X9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710971409; c=relaxed/simple;
	bh=/iVDOceRDKO+YQA2Qfr9OdBjpSfBGK9xowhO0F253Uc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MWtZ4P/aglV2S3jia9n6yo79SBUbTUkF3p2Fq5vVAK5ex2pbRVmmQ7EzFiFMCNuwbhK8vYZFe2J/NOZBIkCN56RyG9VmzLyfosWp02xm67wV7RqwvRVLL6ivZrlwPg2feaYx5sT8crz2sm3SLz6pRuVXeIwUVy9ZIimh5w73mNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=R7JRvwyi; arc=none smtp.client-ip=209.85.221.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="R7JRvwyi"
Received: by mail-vk1-f179.google.com with SMTP id 71dfb90a1353d-4d452e2f0aeso112601e0c.1
        for <linux-bcachefs@vger.kernel.org>; Wed, 20 Mar 2024 14:50:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710971407; x=1711576207; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lOO/W2PrEFdSmfiqRhj6ihRZAdrjUruvyiQSAQOVQC8=;
        b=R7JRvwyi+2XpNbr6qGwbgSktCe8ERIlFxcStW33QWJhpIgSPiN2SULiVkfznZuUQMb
         Q3SLwyG/KaGF4eHok4Ut5D7e6YKAUpimrEQbc9TZlbeuwMAX/Aq1he0yoTRM9GmR6xb2
         xMmwSc4hN1CG3ttTADiCY3W69AmNeZpdZuqg3RgUJxE4qUF+iBTp3h3p6ozClVECEEM3
         L2dLRW2u5HxG9ydYvStn7kk3j73nSveHeO7j2+LiHAdEiCL6DKWQhPFzpd1H4S/MyOkn
         qX3VeS08wXMLjS5U1tfg7U9nbNmhWLq9EyzrLwvueYeWh89/oqiMAfOBMac8+zrwx+zz
         aCAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710971407; x=1711576207;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lOO/W2PrEFdSmfiqRhj6ihRZAdrjUruvyiQSAQOVQC8=;
        b=L9Ec63+O9olr3l42gbsdQdRYtvM2Xu1Jq/V0T2oEdrdG/TSXn7ystTf50x4NfNh+bc
         O+IlI+w/k+Q9qpARBNmXGKH4UVHq0mOhe8DmkO2dYsp94kyq+3qXrTb/oyrCxEeMZtfD
         g7rt+dh5YR3EUAOp494IhGXWzCb8uITpbJkuzWxelgNhm4ekNAyoDS3sC/pKw4zTgXGj
         cpBN259p5gWmPCdFzdpd1YaeX6VFd112H3n5B/KCHhI3cyo8xw7oY0fkxoRKytewyX1q
         mBuYkqf9MqO1C+hry2A/F0dlVUKxUaHeuqYQcVUurd+GcMXEg32zOoAZCtAZsvichLi3
         /QCg==
X-Forwarded-Encrypted: i=1; AJvYcCX84JaIA0sna4YOZY8iKp1qB2Lvx6XKxO+nXTZJbFYBY/n8lTRCsoKEm2UqWKYfj37Ds0GeV2YRI2nO2WNDklTtQTjLCvTUDNSCO/4d4SQ=
X-Gm-Message-State: AOJu0YzhioCvzeCI6eB1Hoe4hUaeyhcV2D2MtD0a8fNp556I/sXqd0sm
	17JCnO/WtGKS252pG7iPUC9mV4gpe80ayfRQanUXh5Wrwv1YwQn6
X-Google-Smtp-Source: AGHT+IGOo46KeI82Bi/hMMacz3MTOiiPRmuYCcOlx3kP7nAbpF5MhVYWRESn7mah5TGROtzzQWKdgA==
X-Received: by 2002:a05:6122:1d8a:b0:4d4:2931:7d4d with SMTP id gg10-20020a0561221d8a00b004d429317d4dmr151741vkb.5.1710971406695;
        Wed, 20 Mar 2024 14:50:06 -0700 (PDT)
Received: from [10.193.190.170] (mobile-130-126-255-72.near.illinois.edu. [130.126.255.72])
        by smtp.gmail.com with ESMTPSA id jz5-20020a0562140e6500b006961cdc3f7csm4152045qvb.85.2024.03.20.14.50.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Mar 2024 14:50:06 -0700 (PDT)
Message-ID: <7cd00c69-4130-45d8-a863-3254031b27d2@gmail.com>
Date: Wed, 20 Mar 2024 16:50:05 -0500
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [fs/bcachefs] Question about memory allocation in
 btree_paths_realloc
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: bfoster@redhat.com, linux-bcachefs@vger.kernel.org, chenyuan0y@gmail.com
References: <080de8c1-497c-45aa-a5a0-10dba5319c64@gmail.com>
 <bblgnrjjvyisunthmn4ti667nqyr5pglr5rws4kxalkxvs2wi4@k7w7ekoc2wru>
Content-Language: en-US
From: Zijie Zhao <zzjas98@gmail.com>
In-Reply-To: <bblgnrjjvyisunthmn4ti667nqyr5pglr5rws4kxalkxvs2wi4@k7w7ekoc2wru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/20/24 4:48 PM, Kent Overstreet wrote:
> On Wed, Mar 20, 2024 at 04:37:02PM -0500, Zijie Zhao wrote:
>> Dear BCACHEFS maintainers,
>>
>> We encountered an unusual usage of kzalloc in btree_paths_realloc while
>> performing a static analysis for kernel code.
>>
>>
>> https://elixir.bootlin.com/linux/latest/source/fs/bcachefs/btree_iter.c#L1523
>>
>> ```
>> static noinline void btree_paths_realloc(struct btree_trans *trans)
>> {
>> 	unsigned nr = trans->nr_paths * 2;
>>
>> 	void *p = kzalloc(BITS_TO_LONGS(nr) * sizeof(unsigned long) +
>> 			  sizeof(struct btree_trans_paths) +
>> 			  nr * sizeof(struct btree_path) +
>> 			  nr * sizeof(btree_path_idx_t) + 8 +
>> 			  nr * sizeof(struct btree_insert_entry), GFP_KERNEL|__GFP_NOFAIL);
>>
>> 	unsigned long *paths_allocated = p;
>> 	memcpy(paths_allocated, trans->paths_allocated,
>> BITS_TO_LONGS(trans->nr_paths) * sizeof(unsigned long));
>> 	...
>> }
>> ```
>>
>> Here kzalloc might return NULL in case of out-of-memory, making
>> memcpy(NULL,...) to have undefined behavior. Would a NULL check be needed
>> here?
> 
> See that __GFP_NOFAIL?

Thanks! Just realized that!
