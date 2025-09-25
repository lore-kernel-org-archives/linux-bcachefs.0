Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E31A72C17B2
	for <linux-bcachefs@vger.kernel.org>; Thu, 25 Sep 2025 14:26:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758810404; cv=none; b=JgtOZF7H4b1Gf5+cZCZ8cz/WYt+kFXxkT+I14vchL2oI94H6B0rgfNQD6+eXMEGx09+fFusQ+qz7J9hOvCEdefPZI2zb+kU0Boyv881HZjWjCFQIim9sfxJjPKrPQHarqJN4rxrIFSxVeOU03FN8wyUV3BqOGNluC87HxsNnpBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758810404; c=relaxed/simple;
	bh=D8wsuOOGG1VyLhZ0JxFPIQTVvR8s+TjTt638B6XCb2w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OYt1BrE2OG1OcKzdKTp5U4mRK/uxekCODQV64aBYjGKnJ8+r8qlxxge9YcOPv1XP1PBN0weuffPefh5Kh5E+MGmSejSDvI2fKwlAkddYRnVddFq+71pFV9/cAZ2xzrlsW37owIDAjENEcPvvvXHGsOfUTy+yxySsNG2ikEZ4c+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cov1LflE; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cov1LflE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758810401;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=7NbQWxxCkkna6kPG5JPAnaAdZblXa8Jj1l6IA0HQVeA=;
	b=cov1LflEGC16Rei+iT6tZ+LPurdrLCoLUhEocK7XYV0hydH/Uk8yrCwLwDUdVzK/uu/xUO
	o/Tcs5cC3XG9mF8l8GIwd9iNq+Zrh/8XCQR0/6Vz/FdNmJ+gVb4KwKjfrij6AbkD+wccTx
	zf4dgaO68Egnqu//3uhoYHiQ1QkBnDA=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-114-yjRrsKYrPUC0wgY0D05zQA-1; Thu, 25 Sep 2025 10:26:39 -0400
X-MC-Unique: yjRrsKYrPUC0wgY0D05zQA-1
X-Mimecast-MFC-AGG-ID: yjRrsKYrPUC0wgY0D05zQA_1758810398
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-46e35baddc1so5937725e9.2
        for <linux-bcachefs@vger.kernel.org>; Thu, 25 Sep 2025 07:26:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758810398; x=1759415198;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7NbQWxxCkkna6kPG5JPAnaAdZblXa8Jj1l6IA0HQVeA=;
        b=QjEqMqMZcriXxcv/2XZ1bjUeckbO1L6o42ovijnEEm7Xj3M9aoKlNIzuS6PHAzzqe3
         CRxdnvhAJX2g8ZGjQt/Eku0RjS3Je25bwBh24v24Pd1A1VmRU8PkwJDvkTwuOFhSShXY
         1GcvtKiE+V9qZNJ567uwPNQ0mSnUmD3artz8HhccUGO4kElxWT6JHPd6HM28Y1VvTP9d
         IadxjGAt2ez7iRIkiCzF7H9GHCLpSvyUzCiabYI/YTd7BvMD/fejXGM6N+GBP9RzhxsS
         WOc5RSiaPDrEIo1D1qm1RcIs+QvciD11VxSvwIFBVVWjHCAm4TsiGuSbrAE3zc78YmZg
         NRFg==
X-Forwarded-Encrypted: i=1; AJvYcCU+GPyfRnOjWyb+YnFar3ZedQhjAu/ZAzr+UN00hnD2/GGxoSHAyea102PoZQ5/NdzPupadDrxDWRQ9U10IKA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzlHq9lGisv4luFpUMiKlzCDq+N5MKDastb3EEFxyEQsMIDRZqx
	glzBXhPZF79FnJfyhjunvja3uH1bcdU4xj1dWS0hAJfpBNdX2hXsP44unVZSnocJsnOx86627Q9
	i/lr1SVX0WK6SxgjtChHd1M/IwwIcrMtHi4q0MglOMBSbR6YMlc88aGzYXJ1hLyjj79xS
X-Gm-Gg: ASbGnct8+vxM0yemFJ2yHl5k4oM3ONzsFRUIxj/M2uZfqb2j20UPZTLCM+M2jeXFaot
	NLep8l51AY6cfRfuNMEaMaIR0SBMQDng80BCuZXGKIb/AG0awPvQyGtD4P7gve2tw7yIsBX04Bd
	6ppHTxG0mZ0R5b0+Bq5hzWxVrsW/4s9NVzmP5TyP+uFddSWUdCsUPee7u0ryO0eYCsP6WUtG3UM
	4wA38ttP07VzOr/gIhOZIe8lr/VN8Vv2kBdsU6u40nCqydAzax61gUpd6jX2KZLUtYf0yw6N9p8
	Jd8fIzCy5O+OdDUM3M8gNqKbNfJKs058SRhtezVIz3SAa5u0F6brMWXmfEK5ZlnhT23XSPCH6U8
	cbEWhC3UqWtgJHeko3SweYfbRcmqki+QJ9GPKe8HqZ4eg3eG8OyJwOGAo30lepDazLuXn
X-Received: by 2002:a05:600c:4e8b:b0:46e:37fc:def0 with SMTP id 5b1f17b1804b1-46e37fce148mr14762955e9.9.1758810398069;
        Thu, 25 Sep 2025 07:26:38 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHjZJ0WBMi2SLpg5brCAPP2ix/UVmUI6Mp8N0XKACsUKpJXXguXTVe5P/uAzXY2rpR891e88g==
X-Received: by 2002:a05:600c:4e8b:b0:46e:37fc:def0 with SMTP id 5b1f17b1804b1-46e37fce148mr14762275e9.9.1758810397527;
        Thu, 25 Sep 2025 07:26:37 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f3f:f800:c101:5c9f:3bc9:3d08? (p200300d82f3ff800c1015c9f3bc93d08.dip0.t-ipconnect.de. [2003:d8:2f3f:f800:c101:5c9f:3bc9:3d08])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e33bf6ecbsm39061825e9.22.2025.09.25.07.26.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Sep 2025 07:26:36 -0700 (PDT)
Message-ID: <3a82a197-495f-40c3-ae1b-500453e3d1ec@redhat.com>
Date: Thu, 25 Sep 2025 16:26:32 +0200
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH kvm-next V11 4/7] KVM: guest_memfd: Use guest mem inodes
 instead of anonymous inodes
To: Sean Christopherson <seanjc@google.com>
Cc: Shivank Garg <shivankg@amd.com>, Ackerley Tng <ackerleytng@google.com>,
 willy@infradead.org, akpm@linux-foundation.org, pbonzini@redhat.com,
 shuah@kernel.org, vbabka@suse.cz, brauner@kernel.org,
 viro@zeniv.linux.org.uk, dsterba@suse.com, xiang@kernel.org,
 chao@kernel.org, jaegeuk@kernel.org, clm@fb.com, josef@toxicpanda.com,
 kent.overstreet@linux.dev, zbestahu@gmail.com, jefflexu@linux.alibaba.com,
 dhavale@google.com, lihongbo22@huawei.com, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, ziy@nvidia.com, matthew.brost@intel.com,
 joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com,
 gourry@gourry.net, ying.huang@linux.alibaba.com, apopple@nvidia.com,
 tabba@google.com, paul@paul-moore.com, jmorris@namei.org, serge@hallyn.com,
 pvorel@suse.cz, bfoster@redhat.com, vannapurve@google.com,
 chao.gao@intel.com, bharata@amd.com, nikunj@amd.com, michael.day@amd.com,
 shdhiman@amd.com, yan.y.zhao@intel.com, Neeraj.Upadhyay@amd.com,
 thomas.lendacky@amd.com, michael.roth@amd.com, aik@amd.com, jgg@nvidia.com,
 kalyazin@amazon.com, peterx@redhat.com, jack@suse.cz, hch@infradead.org,
 cgzones@googlemail.com, ira.weiny@intel.com, rientjes@google.com,
 roypat@amazon.co.uk, chao.p.peng@intel.com, amit@infradead.org,
 ddutile@redhat.com, dan.j.williams@intel.com, ashish.kalra@amd.com,
 gshan@redhat.com, jgowans@amazon.com, pankaj.gupta@amd.com,
 papaluri@amd.com, yuzhao@google.com, suzuki.poulose@arm.com,
 quic_eberman@quicinc.com, linux-bcachefs@vger.kernel.org,
 linux-btrfs@vger.kernel.org, linux-erofs@lists.ozlabs.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-security-module@vger.kernel.org, kvm@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-coco@lists.linux.dev
References: <20250827175247.83322-2-shivankg@amd.com>
 <20250827175247.83322-7-shivankg@amd.com> <diqztt1sbd2v.fsf@google.com>
 <aNSt9QT8dmpDK1eE@google.com> <dc6eb85f-87b6-43a1-b1f7-4727c0b834cc@amd.com>
 <b67dd7cd-2c1c-4566-badf-32082d8cd952@redhat.com>
 <aNVFrZDAkHmgNNci@google.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <aNVFrZDAkHmgNNci@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 25.09.25 15:41, Sean Christopherson wrote:
> On Thu, Sep 25, 2025, David Hildenbrand wrote:
>> On 25.09.25 13:44, Garg, Shivank wrote:
>>> On 9/25/2025 8:20 AM, Sean Christopherson wrote:
>>> I did functional testing and it works fine.
>>
>> I can queue this instead. I guess I can reuse the patch description and add
>> Sean as author + add his SOB (if he agrees).
> 
> Eh, Ackerley and Fuad did all the work.  If I had provided feedback earlier,
> this would have been handled in a new version.  If they are ok with the changes,
> I would prefer they remain co-authors.

Yeah, that's what I would have done.

> 
> Regarding timing, how much do people care about getting this into 6.18 in
> particular?

I think it will be beneficial if we start getting stuff upstream. But 
waiting a bit longer probably doesn't hurt.

> AFAICT, this hasn't gotten any coverage in -next, which makes me a
> little nervous.

Right.

If we agree, then Shivank can just respin a new version after the merge 
window.

-- 
Cheers

David / dhildenb

