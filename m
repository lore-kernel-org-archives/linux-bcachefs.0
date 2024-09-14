Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5428118B09
	for <linux-bcachefs@vger.kernel.org>; Sat, 14 Sep 2024 04:58:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726289897; cv=none; b=A11e7kRBrsaprdquAzoQ5tr4+p+kvL/PRk/hy8ilsxbK0WxiQqlH7Z9Qeoi1m7pTcMEhq/NEEMy2YqPKjEuLxEizXGaj6OMYS3GEG6pIsSU5XyETRhvUumSsyEBtRGkeZNX5Iwc9bjVHVMITm5qSb8P8hfy3v26zJNxqbY/9imw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726289897; c=relaxed/simple;
	bh=ExqbsHYW5CWOyuYZgCevMm5VAMvWKDwA9H1WBjjyLT0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gdYAy/9ACJaZBBFUdHT7ncZ54g6ljH0nmQ4Oh+gmy/meW3c7buH+6XOpn2EQ8lMV8PIDjn45JqVe9Bl6ok4BCEcYi/0HIYlKihqYlT9r7RK63iu9Uy4HGSHpoB4RGhGQZjobzkl8FqPDsGkD+5CD2lOCuTN2beQyI0+pfc6zkK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KL+EOVrL; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KL+EOVrL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1726289893;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=M56LrAmwkApLC8iN+C8xdLKdu0WwTZ3zB5sb1jAVOaM=;
	b=KL+EOVrLLaj6+vkGPYw3FA4Ojwvw8MdyNjYRn+2LJI8LUONmfpWIvnuEQeMKj3CORRhWlB
	O4nc4RprjN2jlbYFP3mR2AuCxv3q/Anr36Y0Lz9leSlAQK6JkK03E5Ws+wLJkv8LCd2+y4
	pG1gL/LfyDw7u5jDblWffn7sN2louUw=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-428-qyWl_HAhO9SoMqzixAwj3g-1; Sat, 14 Sep 2024 00:58:11 -0400
X-MC-Unique: qyWl_HAhO9SoMqzixAwj3g-1
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-7163489149fso3574281a12.3
        for <linux-bcachefs@vger.kernel.org>; Fri, 13 Sep 2024 21:58:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726289890; x=1726894690;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=M56LrAmwkApLC8iN+C8xdLKdu0WwTZ3zB5sb1jAVOaM=;
        b=VddWWQLnaMxNf91Csz/YdtilcERrykgvBQkRVvXymrK4Ad8PpaYrtZUIXyJYTzQDxR
         7F7NwdBqhyVCL5jJZFS2AWAaDPHl7qPkwL1mlPjelypmcjnQehgUf814VhU7DSpk0EFz
         pTz+4m59ufGR+OecYMhpQmZArZyzivaEy3SR82nrtnjGIXdyNqevVOK25dobqdS/5c2Q
         ytfWpojVhHKd2pu4smzwfBRMe02ffC9zpW1VYdBBdHzYDRC2XlIYoRC+mFIp9KPKJv/X
         UxQpuEOLZFF5FlYNFJKwh4iqZWihZFe8DuBEz7sppWPCuvIDqKM+jAk4CdgeaCXnP4Wj
         j5vw==
X-Forwarded-Encrypted: i=1; AJvYcCWSirj7RFnWsVVJxe/FRM+QWPLNJh8DLhEEKq5W9xS2+OKy4avqFPDNa84xNEHUEcWcPiOeg5VGbClB1VkVAA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx/GWl9hp3p8WdbgOObsE5+tVSnCO4tR1+1txKUL9C5oLcVzS17
	dCDgIfl71ht1YregrYZLa88K1C4tTSZkJ6Za6MVzxcQwgt4V480xIQc/a+gGQJbI2iYVKSsHekb
	sG3SZdRJw+iJPxuuCnCEKcJH9TvopyEWImdBWt9eYm++Y3vbtq3h8x/5KNENrodfluLdsoE4BDk
	0=
X-Received: by 2002:a17:90b:111:b0:2da:d2a2:4a71 with SMTP id 98e67ed59e1d1-2dba0082efamr9188265a91.40.1726289889659;
        Fri, 13 Sep 2024 21:58:09 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGoyRN8TqnptNO64VjJu3ITC4mxSXMhAKYujRIs0cD01yIivmnevAIV4aorD0PypZCy3lfV0A==
X-Received: by 2002:a17:90b:111:b0:2da:d2a2:4a71 with SMTP id 98e67ed59e1d1-2dba0082efamr9188235a91.40.1726289888834;
        Fri, 13 Sep 2024 21:58:08 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2dbcfdc0ac3sm552050a91.53.2024.09.13.21.58.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Sep 2024 21:58:08 -0700 (PDT)
Date: Sat, 14 Sep 2024 12:58:05 +0800
From: Zorro Lang <zlang@redhat.com>
To: Alyssa Ross <hi@alyssa.is>
Cc: fstests@vger.kernel.org, linux-bcachefs@vger.kernel.org
Subject: Re: [RFC PATCH] generic: test negative timespecs are accurate
Message-ID: <20240914045805.2htdxbt5bmd2hh6u@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20240907154527.604864-2-hi@alyssa.is>
 <20240909080132.4wliimcb2y4bt7u3@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <8734m7hlnm.fsf@alyssa.is>
 <20240910135226.hfwk774mdzztqdxv@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <87zfofczz0.fsf@alyssa.is>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87zfofczz0.fsf@alyssa.is>

On Tue, Sep 10, 2024 at 05:04:03PM +0200, Alyssa Ross wrote:
> Zorro Lang <zlang@redhat.com> writes:
> 
> > On Tue, Sep 10, 2024 at 12:02:05PM +0200, Alyssa Ross wrote:
> >> Zorro Lang <zlang@redhat.com> writes:
> >> 
> >> > On Sat, Sep 07, 2024 at 05:45:28PM +0200, Alyssa Ross wrote:
> >> >> Link: https://github.com/koverstreet/bcachefs/issues/743
> >> >
> >> > Great, a bcachefs regression test case :)
> >> >
> >> > Can you add a bit more details in commit log, not only a link.
> >> >
> >> >> Signed-off-by: Alyssa Ross <hi@alyssa.is>
> >> >> ---
> >> >> This is an adapted version of generic/258, but it tests that the stored 
> >> >> timestamp is accurate to the second, rather than just testing the 
> >> >> timestamp remains negative.  I created a new test rather than just
> >> >> making 258 more precise, because I understand that there may be
> >> >> filesystems that don't store timestamps that accurately by design.
> >> >> As an example, I've heard that FAT only has 2 second precision, so this
> >> >> patch is an RFC because I'm not sure how I should write a _require
> >> >> function (if at all) that restricts the test to filesystems that are
> >> >> expected to be able to do this.
> >> >> 
> >> >>  tests/generic/363     | 26 ++++++++++++++++++++++++++
> >> >>  tests/generic/363.out |  2 ++
> >> >
> >> > The g/363 has been taken, please rebase to latest for-next branch.
> >> > You can use `xfstests/tools/mvtest generic/363 generic/365` to change
> >> > the case number, before rebasing.
> >> >
> >> >>  2 files changed, 28 insertions(+)
> >> >>  create mode 100755 tests/generic/363
> >> >>  create mode 100644 tests/generic/363.out
> >> >> 
> >> >> diff --git a/tests/generic/363 b/tests/generic/363
> >> >> new file mode 100755
> >> >> index 00000000..50459d01
> >> >> --- /dev/null
> >> >> +++ b/tests/generic/363
> >> >> @@ -0,0 +1,26 @@
> >> >> +#! /bin/bash
> >> >> +# SPDX-License-Identifier: GPL-2.0
> >> >> +# Copyright (c) 2011 Red Hat, Inc.  All Rights Reserved.
> >> >> +# Copyright (c) 2024 Alyssa Ross.  All Rights Reserved.
> >> >> +#
> >> >> +# FS QA Test 363
> >> >> +#
> >> >> +# Test timestamps prior to epoch with nanosecond components are
> >> >> +# accurate to the second.
> >> >> +# bcachefs was slightly off.
> >> >> +#
> >> >> +. ./common/preamble
> >> >> +_begin_fstest auto quick bigtime
> >> >> +
> >> >
> >> > As this's a bcachefs regression test:
> >> > https://lore.kernel.org/linux-bcachefs/20240907160024.605850-3-hi@alyssa.is/
> >> >
> >> > So better to mark as:
> >> > if [ "$FSTYP" = "bcachefs" ];then
> >> > 	_fixed_by_kernel_commit xxxxxxxxxxxx "bcachefs: Fix negative timespecs"
> >> > fi
> >> > (replace the xxxxxxx if it's merged on mainline linux)
> >> >
> >> > Others looks good to me, with above changes, I'd like to
> >> >
> >> > Reviewed-by: Zorro Lang <zlang@redhat.com>
> >> 
> >> Thanks!  So you don't think the test needs to express any extra
> >> requirement that filesystems support to-the-second precision?
> >
> > Oh, does this test needs 1 second precision? I thought you concerned some
> > filesystems cannot be the epoch you set. The _require_negative_timestamps
> > will skip the test from exfat and ceph. It doesn't help the FAT, maybe you
> > want to add vfat to _require_negative_timestamps.
> >
> > I thought you might want to output the stored timestamp (accurate to the
> > second) to reproduce this bug, if not, why you hope to write this new one,
> > not use the g/258 to be the reproducer directly?
> 
> I'm sorry, I don't understand the question.  I explained why I created a
> new test in my commentary — g/258 doesn't require 1 second precision,
> and this test does.

Sorry, I mixed several questions together. I mean:

1) Can g/258 reproduce this bug. If not, that means you need the accurate
"-14245441" output, which might break the test on fs not support to-the-second
precision, right?

2) If the 1) is yes. Then I think this case doesn't need to care about
"fs not support to-the-second", as you say you don't have a good way to
"_require" that.

3) If you agree 2). I think most of filesystems (fstests supports) support
the to-the-second precision. And the _require_negative_timestamps() helper
can help to skip this test from some improper filesystems for this test.
If you concern vfat, you can add it beside the exfat in that helper.

4) If the 1) is right, the fs which doesn't support to-the-second precision
also can be added into the blacklist of "_supported_fs" now or later, e.g.
_supported_fs ^cifs.

Hope I explain clearly this time :)

Thanks,
Zorro

