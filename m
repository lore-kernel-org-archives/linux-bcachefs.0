Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67CBB27E7EC
	for <linux-bcachefs@vger.kernel.org>; Tue, 22 Jul 2025 17:55:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753206919; cv=none; b=kWeRw5D1ytab2EcdZxF4FlQVTadVnXoYdyT7TYu9mPW39w508oSIIytFsBxwpDPJTgr53ShIO3AspipvIyin/BEGg5P3Jfb5CUfKegikk1ECGMIBfDiTuxALjWf0Qu3RxeU5OM+r7dFgAzD7yUaOhyCAoqkDyGjFeo5DlPHwzuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753206919; c=relaxed/simple;
	bh=+JUCvse9/Q0h83pSfOVoqRwPa3cwg92XlBECM4wBwMg=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=i5WoiObaWzuk1ifkoAi+grwjlbxKgIV3UblTBIxEeu7yxyWqa3aCaOcSTcH4h2LshaI+WEmzHnMK8Hfb87kW3MfLhpeDSww85lipWLSrD2T+N2akGD7S7Uk0OFbIByL4sh8Qy3T3wx+RPJ5flWzqklhK/VzzUfT2bxVoH6Qa20I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-87326a81ceaso15201139f.1
        for <linux-bcachefs@vger.kernel.org>; Tue, 22 Jul 2025 10:55:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753206917; x=1753811717;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+JUCvse9/Q0h83pSfOVoqRwPa3cwg92XlBECM4wBwMg=;
        b=WqpQt1qFdd2b3xwt7qMrvvZFXW/Jkx9pjP1UZRvOVaYwpofVvUAyfVUe28R4mhWv26
         9jMcwBaq6SoKXBMHfr62e+z5iztmZPbtZc/ZLh1QuKomiiUEOh2y0usvF0I9+LxpBhV2
         fL8UeHXz+MvbFrdozK9Bawq7piB0HoeUXpiWwYNrj4bwH2oMej5vS23fqnlcYHhH39t5
         UM6anGPuQsrTdw47Z5t9xeNZccLQBIwkNYPGn1ckO32sZBIfqvUz2G3msFCtzES2oAm4
         IeVnSGx30VZjcFkysT4jxwpptWVMNnMyFjmHTRhNzo6XmpCdrDk5jnTGKfPq/hFbiOCE
         J0zg==
X-Forwarded-Encrypted: i=1; AJvYcCWB9H3MS3drFsxTtq7CsKHs5iaEbiw2W95gtm6aLF/Om5hgrDBReiJji+UR77IMKnz2IN5L9qH5vvTqrdiLhQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz9k/rAKcOAOHHd9hPD19bSfcNzhRkN26VN3FMKwU8qA01ll3Ef
	UBCp+Mx4BV1ivKZ6adJNrMHffqMJBFSA0LHO5Ggc81CbU410HnJlLaVK1tq6e5WM0+IH7zoMArd
	fwTVpePfaOdFbUANwYMrmFE60eWbBCISkmUKrNUuAHatIZWvmdEpceusSoQ0=
X-Google-Smtp-Source: AGHT+IEnZCeH751BFdoEhmWWVC/2QU/u1JIWsR5UBGORLRUIn04iBieQDH4T7gcYQHSc9SnRnLic3XPmpo3B+yrD3wmrwVToKop5
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:4746:b0:876:b17c:dec3 with SMTP id
 ca18e2360f4ac-87c5389b0e8mr829314939f.8.1753206917538; Tue, 22 Jul 2025
 10:55:17 -0700 (PDT)
Date: Tue, 22 Jul 2025 10:55:17 -0700
In-Reply-To: <xq4a62ukblverdhefpn3e43dkhaxvk2brdytqonrbzy3mud76m@srllmpvcv4e5>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <687fd085.a70a0220.693ce.0107.GAE@google.com>
Subject: Re: [syzbot] [block?] [bcachefs?] kernel panic: KASAN: panic_on_warn
 set ...
From: syzbot <syzbot+4eb503ec2b8156835f24@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev
Cc: brauner@kernel.org, jack@suse.cz, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-block@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"

> On Sat, Apr 19, 2025 at 08:23:50AM -0400, Kent Overstreet wrote:
>> I'm not sure which subsystem this is, but it's definitely not bcachefs -
>> we don't use buffer heads.
>
> I think there's some incorrect deduplication going on with this bug,
> some of the reports do not look closely related, I believe they're all
> buffer heads related.
>
> #syz set-subsystems: block fs

unknown command "set-subsystems:"

