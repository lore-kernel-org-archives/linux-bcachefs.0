Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F241B30B50E
	for <linux-bcachefs@vger.kernel.org>; Thu, 16 Oct 2025 14:17:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760624254; cv=none; b=aJfV4+FdHhhR6nXQ27SUQWH9M7kBQwYqJcaEVoWzlfc0M9fSkNlz4os9jkjT5cZ4hEETyseiJHNADbEzC6JOsyoJMaskArpuSKPgi80cro06djOQIx9hNUNjm4H5nJLJi2vI8Wk5VbrtaqDY7r5rnF0alSd3JytJfjImISjKchU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760624254; c=relaxed/simple;
	bh=MjX01ygQ/3tk/sGwgwk/36ebQMdAkveFRCJrUinD/Og=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Wqn1JpTqMSM4B8qiiSYEDQHZSC1ftTxZzRIXb1tHYcFmMcOIFNiciu6K3PQ1TdS/wtqeV/WEFW6QCGI6lzdnmW5CZcaImm7nojGE6mbaKlVaPliA9s4IIJJXMRygRZ7p8Iziei6Yz5DPg480c16GZTdra4cnmSMoo1g99PfBuN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=dwCRqlcK; arc=none smtp.client-ip=209.85.219.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="dwCRqlcK"
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-87c1a760df5so11184266d6.1
        for <linux-bcachefs@vger.kernel.org>; Thu, 16 Oct 2025 07:17:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1760624251; x=1761229051; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vDx8+7T+MYrCmWnRteKVa1iC6/sCWZvHc99T+OB8RqU=;
        b=dwCRqlcKPsDQVOHquk4yaz5Cv4fPtBLRWee5G2rzxUKcdtZMxVfMRjn0mDOxVrewwz
         KhG5boJn1F0EHcgdAzDtOfdzxeKOTi86FsXlAOWzMrmH+qmHPIjPHnnbJKnBial5NN2b
         4s7Z9es5jhpxKD0kAxJ8BkzNr5E/4oEnPzEGRDR69OAByvk0p7UU3lTzxrx7vGBSf9Z3
         oFPf1jGc9s4O18ef3Jiycd7b1+QVMzmqQadgc3U4egLfYhQRJcWQGXsUfbZhQjhFupIc
         gADI612o9/2HT+1Ux5P4OzN0RB9D9sj32O8DTRenmNW2We4+C8H08EuCwSxwVtoUYDcS
         l0Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760624251; x=1761229051;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vDx8+7T+MYrCmWnRteKVa1iC6/sCWZvHc99T+OB8RqU=;
        b=tJJEKZiAB2LV/ukfuGlq/rxwwZDm/C5RjobuadANXh7bGBw3pkHgyeNEXhIviKlFDN
         AVQmWtt1HAM9Q/+9ccAkx16/oYv74G+HTYRBxQ5feFFr8WNsF5tb4hRW0qlEDTsK9kUE
         5lor2fyu808CLl9cCPea/GrZFX2aJesDzOFjv3r5TaMxInImlk5qWzTTpeF4h7mBev4h
         N3D++xPKSKZWMcd5qWfNhyx/TlZ1ntRrdN/wnk7Th+QWdpi6wnjPiELuTnqV59Ti6cIp
         vgHBgWNOP3qc19wnLwP81UILPy5xdorgE+B86WJSfahfcjhtjveNuQ+jm3DLFp4ReAPO
         BVsA==
X-Forwarded-Encrypted: i=1; AJvYcCURfMmaacH3olqVUdu3Hvb2hujXPh4h0aj0HTJBZruZrN6tx/AJrgTYoI/xu5TzyBbGs6Wyt7QcpdUYpLD2NQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwPMs1BYVULlbOqvnEa+gifTJvYYmbU7R2tycJqzx9e1ttAaQLx
	AI1r4E7jmIX7qL/HXPDOMyXZJQfNk3rGJ/3W3vFNqiBiD2F1W54DVYqvT1WRdYyZ0oE=
X-Gm-Gg: ASbGnctw2zGlE4uAISY6yTxAe4PQjB3uRE02lJCiH7KSrRTBTavsrIvR4LfYRmKLvri
	er3bss1DupWWm2KQClT+IQDg/o31H7JaQtTOjTxxWy8OwVpUuZFr6RrmY4zRadQ2feBj6LaTLiB
	fjjvnESrEi90CrnNbhSn9CzKOWv4qIO9ujOSc+PEbgTXavcQvShTCNGd3SfB6PgZhBPhSCYBm+7
	9A8Z4HGvVfA7i5eLXli+B158Un8b2XiuW0jRUJv5re171oExNkg2wjQbDlL+1BbSevsDN/7PxAB
	/0FC82WVRll/Vh1wecuGs8y6Z+j3c8tRSGv7UGSzEvekgSQON8+BjT5Ju6QPdXeXUmM+fYgLJv/
	jjFG3oVeFpC25E4gRnJ2YYsf3Um5wNOsSTqZIS42QPTyfowe5k5R/D76Lo1v7XGKlfOSjtmZvxn
	q+hQVQKJcCHeXyninbSOYFuDfwgU7Z2mORLRXxNfoX0iLV4gXGl1SIof73BncY2bJLFNfjeg==
X-Google-Smtp-Source: AGHT+IEMapVQRI0ck2KCGxvEYuBB3a+08a/2JspNz86EbcND1SGuRInp+B2xwxF3NumJMeFQLVJPkQ==
X-Received: by 2002:ac8:5883:0:b0:4e8:99b0:b35e with SMTP id d75a77b69052e-4e89d263140mr4179321cf.30.1760624250594;
        Thu, 16 Oct 2025 07:17:30 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4e8955b07e9sm13309541cf.27.2025.10.16.07.17.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Oct 2025 07:17:29 -0700 (PDT)
Date: Thu, 16 Oct 2025 10:17:25 -0400
From: Gregory Price <gourry@gourry.net>
To: Sean Christopherson <seanjc@google.com>
Cc: Shivank Garg <shivankg@amd.com>, jgowans@amazon.com, mhocko@suse.com,
	jack@suse.cz, kvm@vger.kernel.org, david@redhat.com,
	linux-btrfs@vger.kernel.org, aik@amd.com, papaluri@amd.com,
	kalyazin@amazon.com, peterx@redhat.com, linux-mm@kvack.org,
	clm@fb.com, ddutile@redhat.com, linux-kselftest@vger.kernel.org,
	shdhiman@amd.com, gshan@redhat.com, ying.huang@linux.alibaba.com,
	shuah@kernel.org, roypat@amazon.co.uk, matthew.brost@intel.com,
	linux-coco@lists.linux.dev, zbestahu@gmail.com,
	lorenzo.stoakes@oracle.com, linux-bcachefs@vger.kernel.org,
	ira.weiny@intel.com, dhavale@google.com, jmorris@namei.org,
	willy@infradead.org, hch@infradead.org, chao.gao@intel.com,
	tabba@google.com, ziy@nvidia.com, rientjes@google.com,
	yuzhao@google.com, xiang@kernel.org, nikunj@amd.com,
	serge@hallyn.com, amit@infradead.org, thomas.lendacky@amd.com,
	ashish.kalra@amd.com, chao.p.peng@intel.com, yan.y.zhao@intel.com,
	byungchul@sk.com, michael.day@amd.com, Neeraj.Upadhyay@amd.com,
	michael.roth@amd.com, bfoster@redhat.com, bharata@amd.com,
	josef@toxicpanda.com, Liam.Howlett@oracle.com,
	ackerleytng@google.com, dsterba@suse.com, viro@zeniv.linux.org.uk,
	jefflexu@linux.alibaba.com, jaegeuk@kernel.org,
	dan.j.williams@intel.com, surenb@google.com, vbabka@suse.cz,
	paul@paul-moore.com, joshua.hahnjy@gmail.com, apopple@nvidia.com,
	brauner@kernel.org, quic_eberman@quicinc.com, rakie.kim@sk.com,
	cgzones@googlemail.com, pvorel@suse.cz,
	linux-erofs@lists.ozlabs.org, kent.overstreet@linux.dev,
	linux-kernel@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net, pankaj.gupta@amd.com,
	linux-security-module@vger.kernel.org, lihongbo22@huawei.com,
	linux-fsdevel@vger.kernel.org, pbonzini@redhat.com,
	akpm@linux-foundation.org, vannapurve@google.com,
	suzuki.poulose@arm.com, rppt@kernel.org, jgg@nvidia.com
Subject: Re: [f2fs-dev] [PATCH kvm-next V11 6/7] KVM: guest_memfd: Enforce
 NUMA mempolicy using shared policy
Message-ID: <aPD-dbl5KWNSHu5R@gourry-fedora-PF4VCD3F>
References: <20250827175247.83322-2-shivankg@amd.com>
 <20250827175247.83322-9-shivankg@amd.com>
 <aNVQJqYLX17v-fsf@google.com>
 <aNbrO7A7fSjb4W84@google.com>
 <aPAWFQyFLK4EKWVK@gourry-fedora-PF4VCD3F>
 <aPAkxp67-R9aQ8oN@google.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aPAkxp67-R9aQ8oN@google.com>

On Wed, Oct 15, 2025 at 03:48:38PM -0700, Sean Christopherson wrote:
> On Wed, Oct 15, 2025, Gregory Price wrote:
> > why is __kvm_gmem_get_policy using
> > 	mpol_shared_policy_lookup()
> > instead of
> > 	get_vma_policy()
> 
> With the disclaimer that I haven't followed the gory details of this series super
> closely, my understanding is...
> 
> Because the VMA is a means to an end, and we want the policy to persist even if
> the VMA goes away.
> 

Ah, you know, now that i've taken a close look, I can see that you've
essentially modeled this after ipc/shm.c | mm/shmem.c pattern.

What's had me scratching my chin is that shm/shmem already has a
mempolicy pattern which ends up using folio_alloc_mpol() where the
relationship is

tmpfs: sb_info->mpol = default set by user
  create_file: inode inherits copy of sb_info->mpol
    fault:    mpol = shmem_get_pgoff_policy(info, index, order, &ilx);
             folio = folio_alloc_mpol(gfp, order, mpol, ilx, numa_node_id())

So this inode mempolicy in guest_memfd is really acting more as a the
filesystem-default mempolicy, which you want to survive even if userland
never maps the memory/unmaps the memory.

So the relationship is more like

guest_memfd -> creates fd/inode <- copies task mempolicy (if set)
  vm:  allocates memory via filemap_get_folio_mpol()
  userland mmap(fd):
  	creates new inode<->vma mapping
	vma->mpol = kvm_gmem_get_policy()
	calls to set/get_policy/mbind go through kvm_gmem 

This makes sense, sorry for the noise.  Have been tearing apart
mempolicy lately and I'm disliking the general odor coming off
it as a whole.  I had been poking at adding mempolicy support to
filemap and you got there first.  Overall I think there are still
other problems with mempolicy, but this all looks fine as-is.

~Gregory
