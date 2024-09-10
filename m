Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4405418CBE0
	for <linux-bcachefs@vger.kernel.org>; Tue, 10 Sep 2024 13:52:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725976356; cv=none; b=YAjdwyrx+MOMwQA2NujkYFPZ6ikB+krGrfu+ioclw96ja8rd3geldMoagEQ0voGALOGoSHg5oNVmZAusaL2sqqzXC6Ewf+r8CfjMKV7RViAv5kiNnEf4FzOW8UEDDPQU4ewUeiNgbZpZFsoaxWauCNZ2ukKaNtm7mvMyNuQV1uE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725976356; c=relaxed/simple;
	bh=WYj+KNiX2/tFP68pOZTvj5fhWVZOyRDJV7ArUgpxzgQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rEk6DDZGJPi2oZN+Dp2JIwEzwcddOqVgjYZ2+79WaqCMZP2WYw3yJ0crQaAz/z1bIk7VESkTwtP7M3mL6kJcRSFAt2YpogR5L+HUmSzLInXzfber1PFBV/49A4B+dBJinOVnRWfHJzRk8SzCutINBBVAupFWBjUA40EO622lXEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=O7waGRPa; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="O7waGRPa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725976353;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OsHFRXX7atMxb08TJUDPlTcebLtW5BAVtzXT0e3prLA=;
	b=O7waGRPaeQ/y8Hxj2qEyV56lYNfCWQa0NDE6FNzVaLw1eDpMy7JnwzBlsti1cGl3kS1S8W
	9ENh7fTbIxVn025GAgHMaSs8LsiA7o/Ob7rjq51EbnBJTsED0YG81wH8GXV+leN8W4rCT7
	CKgG5cmKtJNDqEJzPeSKbmad2Lf523Y=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-462-HiJIYkBlMgmQTRV_e_kXZw-1; Tue, 10 Sep 2024 09:52:32 -0400
X-MC-Unique: HiJIYkBlMgmQTRV_e_kXZw-1
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-207332f7c17so8120485ad.2
        for <linux-bcachefs@vger.kernel.org>; Tue, 10 Sep 2024 06:52:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725976351; x=1726581151;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OsHFRXX7atMxb08TJUDPlTcebLtW5BAVtzXT0e3prLA=;
        b=MS7GPXvl39fGfRGP3zTVsg4CmoReyC7ExAm8fX98sd35Jq3yt3z8X1bOr/GjjXVJ2s
         WdkxgbL8VKABz+M8la4FpaEb6YYa5ZKTF1TdyaAuvrcQ12Z2T0mL8bxOaosGKHR1vxmm
         GeMLNpMsJH/pi4Us48D9FB+VZ/wEopmgxV+uRzWc258A6nKaymmZmDIAYRDHV4JvMY0F
         mfa6kSwXxQlboxWDyqKCZN/DRXGOCqgOzWE4QT2I5gnzveItQ8hlpF1YMnXn5KeDRxeH
         ILsrUimHaG968OjrRcw0MXXLsepLOWrm6Fr9deo6mnhGovnDnmSLkpjr7LC6v6iKZAlp
         DlgA==
X-Forwarded-Encrypted: i=1; AJvYcCXt93TxDF57zVwiJQE7PZU7utNvh/Ayo734+GbHwLbXxDO2qk28NJG3toOC1MzD0RAPNm4vZ2ELOKufn0oPuA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwdIDcmu2wdNf4KFmsygeyYNUwxC0qk5hGY5BWRYhApWQjAHim0
	3B2scBiLTMb7MJUCUWIDAFP2NCWpQ9Bq0l9mEtidGjsxT0iuiW/WbEUgJNgIBSIAO/olnNoBx2k
	silsVdx93Ipdxz2UreF5z4xVt/kP3TpWE3O9fDDx3fa5UDg8/VgT5XwQJKFNwgcdkeZ1rrr27f6
	8=
X-Received: by 2002:a17:902:e549:b0:207:1828:82fd with SMTP id d9443c01a7336-2074c5f4a70mr9738525ad.28.1725976350745;
        Tue, 10 Sep 2024 06:52:30 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEmCih3+lW6+N+izEA6riY6zhdE7QMXdAIe/jJPGry8gOGWU4t30rI9w3wDRN+Tw1Va38Hadw==
X-Received: by 2002:a17:902:e549:b0:207:1828:82fd with SMTP id d9443c01a7336-2074c5f4a70mr9738155ad.28.1725976350028;
        Tue, 10 Sep 2024 06:52:30 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20710f1f614sm48856725ad.211.2024.09.10.06.52.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Sep 2024 06:52:29 -0700 (PDT)
Date: Tue, 10 Sep 2024 21:52:26 +0800
From: Zorro Lang <zlang@redhat.com>
To: Alyssa Ross <hi@alyssa.is>
Cc: fstests@vger.kernel.org, linux-bcachefs@vger.kernel.org
Subject: Re: [RFC PATCH] generic: test negative timespecs are accurate
Message-ID: <20240910135226.hfwk774mdzztqdxv@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20240907154527.604864-2-hi@alyssa.is>
 <20240909080132.4wliimcb2y4bt7u3@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <8734m7hlnm.fsf@alyssa.is>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8734m7hlnm.fsf@alyssa.is>

On Tue, Sep 10, 2024 at 12:02:05PM +0200, Alyssa Ross wrote:
> Zorro Lang <zlang@redhat.com> writes:
> 
> > On Sat, Sep 07, 2024 at 05:45:28PM +0200, Alyssa Ross wrote:
> >> Link: https://github.com/koverstreet/bcachefs/issues/743
> >
> > Great, a bcachefs regression test case :)
> >
> > Can you add a bit more details in commit log, not only a link.
> >
> >> Signed-off-by: Alyssa Ross <hi@alyssa.is>
> >> ---
> >> This is an adapted version of generic/258, but it tests that the stored 
> >> timestamp is accurate to the second, rather than just testing the 
> >> timestamp remains negative.  I created a new test rather than just
> >> making 258 more precise, because I understand that there may be
> >> filesystems that don't store timestamps that accurately by design.
> >> As an example, I've heard that FAT only has 2 second precision, so this
> >> patch is an RFC because I'm not sure how I should write a _require
> >> function (if at all) that restricts the test to filesystems that are
> >> expected to be able to do this.
> >> 
> >>  tests/generic/363     | 26 ++++++++++++++++++++++++++
> >>  tests/generic/363.out |  2 ++
> >
> > The g/363 has been taken, please rebase to latest for-next branch.
> > You can use `xfstests/tools/mvtest generic/363 generic/365` to change
> > the case number, before rebasing.
> >
> >>  2 files changed, 28 insertions(+)
> >>  create mode 100755 tests/generic/363
> >>  create mode 100644 tests/generic/363.out
> >> 
> >> diff --git a/tests/generic/363 b/tests/generic/363
> >> new file mode 100755
> >> index 00000000..50459d01
> >> --- /dev/null
> >> +++ b/tests/generic/363
> >> @@ -0,0 +1,26 @@
> >> +#! /bin/bash
> >> +# SPDX-License-Identifier: GPL-2.0
> >> +# Copyright (c) 2011 Red Hat, Inc.  All Rights Reserved.
> >> +# Copyright (c) 2024 Alyssa Ross.  All Rights Reserved.
> >> +#
> >> +# FS QA Test 363
> >> +#
> >> +# Test timestamps prior to epoch with nanosecond components are
> >> +# accurate to the second.
> >> +# bcachefs was slightly off.
> >> +#
> >> +. ./common/preamble
> >> +_begin_fstest auto quick bigtime
> >> +
> >
> > As this's a bcachefs regression test:
> > https://lore.kernel.org/linux-bcachefs/20240907160024.605850-3-hi@alyssa.is/
> >
> > So better to mark as:
> > if [ "$FSTYP" = "bcachefs" ];then
> > 	_fixed_by_kernel_commit xxxxxxxxxxxx "bcachefs: Fix negative timespecs"
> > fi
> > (replace the xxxxxxx if it's merged on mainline linux)
> >
> > Others looks good to me, with above changes, I'd like to
> >
> > Reviewed-by: Zorro Lang <zlang@redhat.com>
> 
> Thanks!  So you don't think the test needs to express any extra
> requirement that filesystems support to-the-second precision?

Oh, does this test needs 1 second precision? I thought you concerned some
filesystems cannot be the epoch you set. The _require_negative_timestamps
will skip the test from exfat and ceph. It doesn't help the FAT, maybe you
want to add vfat to _require_negative_timestamps.

I thought you might want to output the stored timestamp (accurate to the
second) to reproduce this bug, if not, why you hope to write this new one,
not use the g/258 to be the reproducer directly?

Thanks,
Zorro




