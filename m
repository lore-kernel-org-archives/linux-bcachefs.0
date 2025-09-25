Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3664B26C3AC
	for <linux-bcachefs@vger.kernel.org>; Thu, 25 Sep 2025 13:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758807711; cv=none; b=BKxRXPG4Cgk5EPduc8kHNYO2F2Pu+W5Dwvgk26qhypezf9Ej6pQAU+EPANLw9MdfAavWjrpYTVUhX138bN4d+MdXic6DFkL0dIxYA4e7/D3sExf6hITlr2YmgDxaGmWazv7owms8Yf7m183ZiwORb41jyRKzXmqDhVrJvWZSsE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758807711; c=relaxed/simple;
	bh=AY4CdJYGfM13VOROhcQg+Kh48EgBR5zHwAOZ2HsNQ/U=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=THYx/5zDb+OmO+1OqerqYxpSxV35k8nsGxzZncpnq+T1q/N8khQMZV7UgUyEAcb01KYx0gV94ORyf3XuZT8fZIQmCKsKvdCL6p5E/4TgTLu9y9jmu87AlgiqYjz41CIkXU5L154IpUX9gjEO9cfkQ8m1cqHCv2CczbUc3AN1IE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Gk3EeibO; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Gk3EeibO"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-32eaa47c7c8so980502a91.3
        for <linux-bcachefs@vger.kernel.org>; Thu, 25 Sep 2025 06:41:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758807710; x=1759412510; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=dU4j5xINCBqy1Rj7i7G1Vfx3gRcoZTHMrIeb9JUSMNk=;
        b=Gk3EeibO1ZMcFGAcEWPL5hFYtzingz6gXXVe/ASHILBBp8JIkEIsVYwd1ZaF9MvWfj
         N4gYNQXa/1zVXGox0ZoGigvTO8b4AbkAjAtyoJuWvjvBeCOu09EyecPoNYG7uwsomFaJ
         LLEqJBGoM6XzQOnYxn51VkO2k5kYRXiwuWpY2PBEqflI25GKMN+VodBGlZwmHtl1IGDI
         w3C2T9OdU/mUgoR6xBhp10hzxlGCo6OElsXX3YEFfZtJoXN5xi9jUK9okgImyP4nP0bG
         Rr2qUKGQnXlqelhxSVQAoVTKvRmMNgEQzM6LpEFtfu2McjZ6TgHrAqCQMS4Kd7mB2BGs
         XoMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758807710; x=1759412510;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dU4j5xINCBqy1Rj7i7G1Vfx3gRcoZTHMrIeb9JUSMNk=;
        b=oYqn6PULaJouqQbZu8soWxjKVQ6EPgXgJM23n5W7IXPRe8HjPPYRSUlbfBdQTbgEW6
         bYZudh2WbXXnZTFqnHpxlnee0HTTh4jRD6xkSJXyNLRXKqnVqp/a7zU8YZiuHulLxDKI
         ezrR8WG77k2bp8P798uqRjoYL5k5YnNGvjQVLPa1BydH9zQN9DsH81VaGLVjUAqupPIv
         RCx/vN7gsAieI4JbT/Qz9pI9HNG+117wzZafeMQ9MtloSdDulaRwMRKHabxAscDdKu1X
         jeA/jAHHEO9hau/d4AD4Oq6jsYtupSnECGJnYu7F6UO3gZv8gRney8ZnqU/SXeK9gmCd
         iSKw==
X-Forwarded-Encrypted: i=1; AJvYcCW3iPNwro6auv1A/eamPCoSJSombNwdOLv7CmGnC2KoEN+Ve9KqYa22b5DUcnPq86YJIpjCNp1DKfv/hIkgaw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzcTDt6R5wCt9Ya5t3ez2pY+RLPfbDYcWPzupX6e17fb8SI5Emh
	4ECtJJ0rSZkml6vXu+R/zCRXmcp0x6kNCrzDzOWP4Mkwb/zDNGdPR+Wb0HLUwW6+OFoY32XYIgl
	dgtBzAg==
X-Google-Smtp-Source: AGHT+IGEjcBsUTlo4/vVd9aOmfS85HeXK7VXkMsc2AM9X82gWAt19f8n9mk94PI8ByiZcVy2ayMJHM96hBY=
X-Received: from pjbjx4.prod.google.com ([2002:a17:90b:46c4:b0:330:88c4:627])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4c4a:b0:334:e020:2f16
 with SMTP id 98e67ed59e1d1-334e0202f83mr1618309a91.11.1758807709301; Thu, 25
 Sep 2025 06:41:49 -0700 (PDT)
Date: Thu, 25 Sep 2025 06:41:42 -0700
In-Reply-To: <b67dd7cd-2c1c-4566-badf-32082d8cd952@redhat.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250827175247.83322-2-shivankg@amd.com> <20250827175247.83322-7-shivankg@amd.com>
 <diqztt1sbd2v.fsf@google.com> <aNSt9QT8dmpDK1eE@google.com>
 <dc6eb85f-87b6-43a1-b1f7-4727c0b834cc@amd.com> <b67dd7cd-2c1c-4566-badf-32082d8cd952@redhat.com>
Message-ID: <aNVFrZDAkHmgNNci@google.com>
Subject: Re: [PATCH kvm-next V11 4/7] KVM: guest_memfd: Use guest mem inodes
 instead of anonymous inodes
From: Sean Christopherson <seanjc@google.com>
To: David Hildenbrand <david@redhat.com>
Cc: Shivank Garg <shivankg@amd.com>, Ackerley Tng <ackerleytng@google.com>, willy@infradead.org, 
	akpm@linux-foundation.org, pbonzini@redhat.com, shuah@kernel.org, 
	vbabka@suse.cz, brauner@kernel.org, viro@zeniv.linux.org.uk, dsterba@suse.com, 
	xiang@kernel.org, chao@kernel.org, jaegeuk@kernel.org, clm@fb.com, 
	josef@toxicpanda.com, kent.overstreet@linux.dev, zbestahu@gmail.com, 
	jefflexu@linux.alibaba.com, dhavale@google.com, lihongbo22@huawei.com, 
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, rppt@kernel.org, 
	surenb@google.com, mhocko@suse.com, ziy@nvidia.com, matthew.brost@intel.com, 
	joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com, 
	gourry@gourry.net, ying.huang@linux.alibaba.com, apopple@nvidia.com, 
	tabba@google.com, paul@paul-moore.com, jmorris@namei.org, serge@hallyn.com, 
	pvorel@suse.cz, bfoster@redhat.com, vannapurve@google.com, chao.gao@intel.com, 
	bharata@amd.com, nikunj@amd.com, michael.day@amd.com, shdhiman@amd.com, 
	yan.y.zhao@intel.com, Neeraj.Upadhyay@amd.com, thomas.lendacky@amd.com, 
	michael.roth@amd.com, aik@amd.com, jgg@nvidia.com, kalyazin@amazon.com, 
	peterx@redhat.com, jack@suse.cz, hch@infradead.org, cgzones@googlemail.com, 
	ira.weiny@intel.com, rientjes@google.com, roypat@amazon.co.uk, 
	chao.p.peng@intel.com, amit@infradead.org, ddutile@redhat.com, 
	dan.j.williams@intel.com, ashish.kalra@amd.com, gshan@redhat.com, 
	jgowans@amazon.com, pankaj.gupta@amd.com, papaluri@amd.com, yuzhao@google.com, 
	suzuki.poulose@arm.com, quic_eberman@quicinc.com, 
	linux-bcachefs@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-erofs@lists.ozlabs.org, linux-f2fs-devel@lists.sourceforge.net, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, 
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-coco@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"

On Thu, Sep 25, 2025, David Hildenbrand wrote:
> On 25.09.25 13:44, Garg, Shivank wrote:
> > On 9/25/2025 8:20 AM, Sean Christopherson wrote:
> > I did functional testing and it works fine.
> 
> I can queue this instead. I guess I can reuse the patch description and add
> Sean as author + add his SOB (if he agrees).

Eh, Ackerley and Fuad did all the work.  If I had provided feedback earlier,
this would have been handled in a new version.  If they are ok with the changes,
I would prefer they remain co-authors.

Regarding timing, how much do people care about getting this into 6.18 in
particular?  AFAICT, this hasn't gotten any coverage in -next, which makes me a
little nervous.
