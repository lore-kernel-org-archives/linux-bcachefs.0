Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37212274B42
	for <linux-bcachefs@vger.kernel.org>; Thu, 25 Sep 2025 13:44:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758807899; cv=none; b=Rz0IBex3CMWBq/85gpIdJ7WNrsUabXziJXR8PylqNDfzPbI95h9ojsctsz2XiPbyfXoJaR80LnTpo5Ma79908Im7NDPCRULVsGC+2kIjYW78ukXTUq5bUG3KdxMZMgMth77aIpOwEOkANo1U9hoI6UMQuM3umaYFV2xbd+ZtQ/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758807899; c=relaxed/simple;
	bh=Z0F6rvv+vHHHgqN2/7WrnWaBdoTfLfsx+4E1sr2dpYo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tIwlnq1m1dA580Q8eRa5tmqJDpM79as+4i3CJMNxRkWS31zeA69WqA4BdMmZ52GRf6662p7SNGGYW5JU6Ahff6E1jvcQXnBqoDo4dC8Hx/qoERB9ufW6u6Ai7Y8Erq+jW2cnOTHKgjZ5rwYXiJZHep+Y8ZDHuY3eqiqRVg/zEgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Gwqrv2UA; arc=none smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Gwqrv2UA"
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-4cb6fea963dso370241cf.0
        for <linux-bcachefs@vger.kernel.org>; Thu, 25 Sep 2025 06:44:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758807896; x=1759412696; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=N5TRZaIKsL5BDWNX1fB2oE8143OJVf1xWjoYHdxo8R0=;
        b=Gwqrv2UA8Ax9RMydlVr9JpasaE19jt+Hwkk1c1vdYAnZtfqiEPHsQxMynF99pQG/IS
         S8OZxZo7rqlTttZ3/KiyDoN0eF9CvW3U1Icncy+Vggtt5ITg3cvEEsINE3Bdw+YLiJwU
         ZojJSpH0r+jF79v9bGTUMSEHIqlAHs1SqWv4KwDamrYyOyvJ5/Y+CRDgO6R6/M02lhWf
         yoJjCmNGR924SUhz6cp0Tw82lX9eW9B3yhFYRk1nxobrOLdS0qBVgDRUn84dFLu3YqcN
         UIXJRlB4/unDwbCsUBg7V+Mm9yc+pUkWa6oPuU2w03cAMTxNxJ4MXZtvPj58sDGwGO7S
         /v5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758807896; x=1759412696;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=N5TRZaIKsL5BDWNX1fB2oE8143OJVf1xWjoYHdxo8R0=;
        b=Lo7SnZ2OxRWL/VVCDlUDbpNBAmBIAARenflAwG73sbz0B95I/9aZTq7q7mxYESR5nF
         Ho7LPs1B/bN0l858Zciot2TcGwq0aDDmw93gJsecN6SDJk94BeVLeHN2Ub4WUvZCkkzq
         Lp23sGWhUXa99oBzh1Bj/1jD//J4+YUUArAZi1l4HY4Y4M9OcSRyUlzP66JCt+3vVXZj
         OeVfVZvZq5bHKCyUFIOve4RCwLI2zjslHEGklNqwq8CpxFBXq8EVe1pV8K6an6yrX0RI
         u+I88gW/7JwtPWXjIrA5DtHNRQjgaXHWswRY0TpGHgn63Yk7udE64dOFnFehqRNiBa8d
         HCqg==
X-Forwarded-Encrypted: i=1; AJvYcCXpIJeSFYM1xXVm+beEaKKIeJIlld0iy/2mXsaR+xNEWaxYpwJ4HGeu29Vz2gNmohQSfLd9Nq9lZt9/bLQkTg==@vger.kernel.org
X-Gm-Message-State: AOJu0YyCH+0Na8XjucOMNatcgS5qGh63G/lEzgVry0FcvnpELdk8UgHq
	6kwNyc9b9V7bvLJA1QGXpdGfjBpRKvb6ro5ZmV8v0CPPW3b5w1E7yH/aDA/XF2JNFWS6pC4XzUL
	OQWebigCsOGxX5vJs9fYJEbK0EG6fJ+2Wn7IGUlkV
X-Gm-Gg: ASbGncs8Y5zmRwnT8rD9tttTmN5+ZJT8OC3ktvrn+wK9uZPbVx5J+cCTfKIBtrPo9yZ
	yrO3WgparXJj+ChMANYR/xwBIewyUShqGjjsC3OQELTPYWQgvsZDbG3HWArITueorExn0+j6eR8
	J0jhTkD+nOA0bo0RknT+gV4EiSViKSbm7qUUdnGwdQab6Y6j2C75wbjxWG3TRqk8YvIUS2A7Mhl
	YYwOYEYPxG+QM/TZ9ORXnSnaA==
X-Google-Smtp-Source: AGHT+IHMjlzJoU4go98o9OLI3ONqf4XSyVwqhgPkrMYYKQ3q5Z+I56IySJAtT5Z6pWwXAgA4n71MeTiHJXaU1zjAWA0=
X-Received: by 2002:ac8:5996:0:b0:4b6:2d44:13c4 with SMTP id
 d75a77b69052e-4da2f12a974mr6481551cf.10.1758807895145; Thu, 25 Sep 2025
 06:44:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250827175247.83322-2-shivankg@amd.com> <20250827175247.83322-7-shivankg@amd.com>
 <diqztt1sbd2v.fsf@google.com> <aNSt9QT8dmpDK1eE@google.com>
 <dc6eb85f-87b6-43a1-b1f7-4727c0b834cc@amd.com> <b67dd7cd-2c1c-4566-badf-32082d8cd952@redhat.com>
 <aNVFrZDAkHmgNNci@google.com>
In-Reply-To: <aNVFrZDAkHmgNNci@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 25 Sep 2025 14:44:18 +0100
X-Gm-Features: AS18NWD8QPp_e9025CtzHt-1GmqDfc-4KC-skp25M5mSn0nTsRNLyfZiLblKLT4
Message-ID: <CA+EHjTz=PnAOdjaPuHRnXE+CTUHCKVSnf-LA6bgwKpWbapy_0Q@mail.gmail.com>
Subject: Re: [PATCH kvm-next V11 4/7] KVM: guest_memfd: Use guest mem inodes
 instead of anonymous inodes
To: Sean Christopherson <seanjc@google.com>
Cc: David Hildenbrand <david@redhat.com>, Shivank Garg <shivankg@amd.com>, 
	Ackerley Tng <ackerleytng@google.com>, willy@infradead.org, akpm@linux-foundation.org, 
	pbonzini@redhat.com, shuah@kernel.org, vbabka@suse.cz, brauner@kernel.org, 
	viro@zeniv.linux.org.uk, dsterba@suse.com, xiang@kernel.org, chao@kernel.org, 
	jaegeuk@kernel.org, clm@fb.com, josef@toxicpanda.com, 
	kent.overstreet@linux.dev, zbestahu@gmail.com, jefflexu@linux.alibaba.com, 
	dhavale@google.com, lihongbo22@huawei.com, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com, 
	rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net, 
	ying.huang@linux.alibaba.com, apopple@nvidia.com, paul@paul-moore.com, 
	jmorris@namei.org, serge@hallyn.com, pvorel@suse.cz, bfoster@redhat.com, 
	vannapurve@google.com, chao.gao@intel.com, bharata@amd.com, nikunj@amd.com, 
	michael.day@amd.com, shdhiman@amd.com, yan.y.zhao@intel.com, 
	Neeraj.Upadhyay@amd.com, thomas.lendacky@amd.com, michael.roth@amd.com, 
	aik@amd.com, jgg@nvidia.com, kalyazin@amazon.com, peterx@redhat.com, 
	jack@suse.cz, hch@infradead.org, cgzones@googlemail.com, ira.weiny@intel.com, 
	rientjes@google.com, roypat@amazon.co.uk, chao.p.peng@intel.com, 
	amit@infradead.org, ddutile@redhat.com, dan.j.williams@intel.com, 
	ashish.kalra@amd.com, gshan@redhat.com, jgowans@amazon.com, 
	pankaj.gupta@amd.com, papaluri@amd.com, yuzhao@google.com, 
	suzuki.poulose@arm.com, quic_eberman@quicinc.com, 
	linux-bcachefs@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-erofs@lists.ozlabs.org, linux-f2fs-devel@lists.sourceforge.net, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, 
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-coco@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

On Thu, 25 Sept 2025 at 14:41, Sean Christopherson <seanjc@google.com> wrote:
>
> On Thu, Sep 25, 2025, David Hildenbrand wrote:
> > On 25.09.25 13:44, Garg, Shivank wrote:
> > > On 9/25/2025 8:20 AM, Sean Christopherson wrote:
> > > I did functional testing and it works fine.
> >
> > I can queue this instead. I guess I can reuse the patch description and add
> > Sean as author + add his SOB (if he agrees).
>
> Eh, Ackerley and Fuad did all the work.  If I had provided feedback earlier,
> this would have been handled in a new version.  If they are ok with the changes,
> I would prefer they remain co-authors.

These changes are ok by me.
/fuad

> Regarding timing, how much do people care about getting this into 6.18 in
> particular?  AFAICT, this hasn't gotten any coverage in -next, which makes me a
> little nervous.
