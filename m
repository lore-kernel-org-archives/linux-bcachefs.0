Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B13B2287269
	for <linux-bcachefs@vger.kernel.org>; Thu, 25 Sep 2025 14:05:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758809125; cv=none; b=W9yajShwSsvofuTqxvcKHIMx3E3O37jDF1SDPGMJFvNBkM9V/odB2qU+Ws8oaWL+Gk9MVWbwtJSYMPUNUM/guZJopm0rqoyMkTBaq94vITzO7lo9FzkI753QkUOUx/OozaJLBz/u4fu4ZNTfQrVCUYJ+i2tVURJ6ps0onBfJYNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758809125; c=relaxed/simple;
	bh=Zevypl+APEAQPrYaQogF8l3UXUYjKvOHk//8MBTIl+U=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YLqfkBhfDTG3X0WyKLTtbQoEMfwmaxE0p3CMAS1A9LbUK42YIAHK6ATu5Jo+GFQgj4j1FLSUhPeiKK/E6qdtjkbcSuIPThKPbI4YfXHkb9AAZ3o31ltl7RRJUYa7ZXTfHMWOjsGryzG/lvECes1AVJ7oRhz9oEeYZTotj/0WsIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WWoVHOZx; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WWoVHOZx"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-32ec69d22b2so1011249a91.1
        for <linux-bcachefs@vger.kernel.org>; Thu, 25 Sep 2025 07:05:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758809123; x=1759413923; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=K3Nb5Uy/w9+ATOrN88r3+4hXRo3JqcPtuKmPJ0+uxMw=;
        b=WWoVHOZxBg46nLCguGCZsRag3PJZ1v5pDN+EMFEg/84FOx10tEn308QxikcGvLopLe
         ka4t0ln/hHAO2f0kgwAEOlYOFMR78TtzlmHmquSqksVQk0YBFaqAYZ67KN9lJsVw4I7d
         3kRT48KjA7yiwrYlIw5PImWoAEH9UIw5ETLoJo+npEmUv290UDbag0GP/4p4jvjpO7Zc
         GQZAbYlgFQ25BQLfrvwvkr5GEPpC8U0nausOuoUbtDfSr5pPaPlorlZ2anynRaJocfL0
         L+/ny68RtmB1NrDRIMLa8l4fchEojlmFKPik6TEG1zqO9wu9tHONCy8SQThhHN5Y5i8v
         q+5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758809123; x=1759413923;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=K3Nb5Uy/w9+ATOrN88r3+4hXRo3JqcPtuKmPJ0+uxMw=;
        b=wWo9Gn4ctRFvg1GArPPUQuHkzCIr19nkqNTGz/3jvEPAGySSqotK5CAHvqOLYXSVco
         /JUq/7WQ8ONZj+v19y0LAuPRkTFKwihikV+tB6zK7G7haVz3ct2hupYZRshiJbtLKSWD
         GGfg5LNkmdmRrRUMF24lcTm1IoU89oPTRmyWMIb1WI9YMF88+mJzj4KNkbqi7nj/gJaI
         wkAPoUvwlb/mat9FETn5JWVVz2FVjIawZzlup8aVHVGrExOueAzFw/ojkGMBvAeQrJ/g
         O4xJ6FUlgZeqQT6H4yHzO9BJ/ShMx0baRWCwc9DrCakrbGHArENyCV5d8LJkfR0eN0di
         6jMg==
X-Forwarded-Encrypted: i=1; AJvYcCUmHdb/7cjZeWttGEK4xydzBpx4j/Am+so+TQsnoEnMssBRKNsD2S2VvS1gYDrzKtV3Uia4lguAhGgCyIx2gg==@vger.kernel.org
X-Gm-Message-State: AOJu0YzqUopu9oxPOjfv0oC1x1Yl/GigvPm9Lu7ADND+Uth+UK2Xu0FO
	i768igUaebi6WR6dV2AlTRf/JKxAWMJwHkIwqI4fAcQMBxnunddyGgAbGV9mdA3SAJOMLA0Ck4g
	QxF20VQ==
X-Google-Smtp-Source: AGHT+IEkjjemcop0vI/vs3xI7IyH1QWjecMMGslQWYv6HGbBMSaTE77RWNjTkPN4A7aBZK5WeU4rCe73+w4=
X-Received: from pjo9.prod.google.com ([2002:a17:90b:5669:b0:32e:e155:ee48])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4f8e:b0:32e:7270:94a4
 with SMTP id 98e67ed59e1d1-3342a22f5c5mr3557648a91.14.1758809122488; Thu, 25
 Sep 2025 07:05:22 -0700 (PDT)
Date: Thu, 25 Sep 2025 07:05:21 -0700
In-Reply-To: <20250827175247.83322-8-shivankg@amd.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250827175247.83322-2-shivankg@amd.com> <20250827175247.83322-8-shivankg@amd.com>
Message-ID: <aNVMIRels8iCldOj@google.com>
Subject: Re: [PATCH kvm-next V11 5/7] KVM: guest_memfd: Add slab-allocated
 inode cache
From: Sean Christopherson <seanjc@google.com>
To: Shivank Garg <shivankg@amd.com>
Cc: willy@infradead.org, akpm@linux-foundation.org, david@redhat.com, 
	pbonzini@redhat.com, shuah@kernel.org, vbabka@suse.cz, brauner@kernel.org, 
	viro@zeniv.linux.org.uk, dsterba@suse.com, xiang@kernel.org, chao@kernel.org, 
	jaegeuk@kernel.org, clm@fb.com, josef@toxicpanda.com, 
	kent.overstreet@linux.dev, zbestahu@gmail.com, jefflexu@linux.alibaba.com, 
	dhavale@google.com, lihongbo22@huawei.com, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com, 
	rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net, 
	ying.huang@linux.alibaba.com, apopple@nvidia.com, tabba@google.com, 
	ackerleytng@google.com, paul@paul-moore.com, jmorris@namei.org, 
	serge@hallyn.com, pvorel@suse.cz, bfoster@redhat.com, vannapurve@google.com, 
	chao.gao@intel.com, bharata@amd.com, nikunj@amd.com, michael.day@amd.com, 
	shdhiman@amd.com, yan.y.zhao@intel.com, Neeraj.Upadhyay@amd.com, 
	thomas.lendacky@amd.com, michael.roth@amd.com, aik@amd.com, jgg@nvidia.com, 
	kalyazin@amazon.com, peterx@redhat.com, jack@suse.cz, hch@infradead.org, 
	cgzones@googlemail.com, ira.weiny@intel.com, rientjes@google.com, 
	roypat@amazon.co.uk, chao.p.peng@intel.com, amit@infradead.org, 
	ddutile@redhat.com, dan.j.williams@intel.com, ashish.kalra@amd.com, 
	gshan@redhat.com, jgowans@amazon.com, pankaj.gupta@amd.com, papaluri@amd.com, 
	yuzhao@google.com, suzuki.poulose@arm.com, quic_eberman@quicinc.com, 
	linux-bcachefs@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-erofs@lists.ozlabs.org, linux-f2fs-devel@lists.sourceforge.net, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, 
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-coco@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"

On Wed, Aug 27, 2025, Shivank Garg wrote:
> Add dedicated inode structure (kvm_gmem_inode_info) and slab-allocated
> inode cache for guest memory backing, similar to how shmem handles inodes.
> 
> This adds the necessary allocation/destruction functions and prepares
> for upcoming guest_memfd NUMA policy support changes.
> 
> Signed-off-by: Shivank Garg <shivankg@amd.com>
> ---
>  virt/kvm/guest_memfd.c | 70 ++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 68 insertions(+), 2 deletions(-)
> 
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 6c66a0974055..356947d36a47 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -17,6 +17,15 @@ struct kvm_gmem {
>  	struct list_head entry;
>  };
>  
> +struct kvm_gmem_inode_info {

What about naming this simply gmem_inode?

> +	struct inode vfs_inode;
> +};
> +
> +static inline struct kvm_gmem_inode_info *KVM_GMEM_I(struct inode *inode)

And then GMEM_I()?

And then (in a later follow-up if we target this for 6.18, or as a prep patch if
we push this out to 6.19), rename kvm_gmem to gmem_file?

That would make guest_memfd look a bit more like other filesystems, and I don't
see a need to preface the local structures and helpers with "kvm_", e.g. GMEM_I()
is analogous to x86's to_vmx() and to_svm().

As for renaming kvm_gmem => gmem_file, I wandered back into this code via Ackerley's
in-place conversion series, and it took me a good long while to remember the roles
of files vs. inodes in gmem.  That's probably a sign that the code needs clarification
given that I wrote the original code.  :-)

Leveraging an old discussion[*], my thought is to get to this:

/*
 * A guest_memfd instance can be associated multiple VMs, each with its own
 * "view" of the underlying physical memory.
 *
 * The gmem's inode is effectively the raw underlying physical storage, and is
 * used to track properties of the physical memory, while each gmem file is
 * effectively a single VM's view of that storage, and is used to track assets
 * specific to its associated VM, e.g. memslots=>gmem bindings.
 */
struct gmem_file {
	struct kvm *kvm;
	struct xarray bindings;
	struct list_head entry;
};

struct gmem_inode {
	struct shared_policy policy;
	struct inode vfs_inode;
};

[*] https://lore.kernel.org/all/ZLGiEfJZTyl7M8mS@google.com
