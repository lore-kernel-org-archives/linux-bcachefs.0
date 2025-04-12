Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46745148832
	for <linux-bcachefs@vger.kernel.org>; Sat, 12 Apr 2025 07:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744442287; cv=none; b=c3qrZ7RHHG1WuKfbSYBZqtZCne7Qmhp3/Q3etrHCKmYd5UIMEU2FPBs2re8+OpPtmV4O+OleDgqD/FfMSqBaEcrKv22nlT53OUbr0QVndSjnTMFUthemryLlJ1hr+el5ubzlqzai1qxQ0AVb3vAxxfAGbyNKhUCyt43McMlPXqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744442287; c=relaxed/simple;
	bh=fh6d+QbbMlA8C6aEiXUD6erPFdsAcrS94snfGQ+OiJs=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=shjRXRM9j+YI1V2nk70Xi9d+NvxpDiXkyvXghcvvfvGxDCHE3CbkVVQ0k8qOrayiaxxAjE97PJp08T5nvmZ3u7pkN8YowbyVBdY+l9dcp3N20QR90k5dIhZkI/VbxWgaZybfRnKssuVD/IxT69q+xd9KqU8UW7BYtqtRsHFC5lI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3d43541a706so25505565ab.1
        for <linux-bcachefs@vger.kernel.org>; Sat, 12 Apr 2025 00:18:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744442285; x=1745047085;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jJTs2Evevi85CfsGwYqFkVtn6aF1t27vAQasOUwnApI=;
        b=Y3FMSTOu+5pIjfnhoPOw5QXPLZ3Je5urYAWjzY/jJ+hss8N5mBg4uMokvbn3qijHZ5
         o1urphTQgxoEwM2Onfosztztaz73TQtJm/x6CgBTUCK4AATE2QE4krpxUq2ULZOFaxPB
         zIvF60Wx+eFINvDb9G6ruC048bRO1XfyDwifMIIIolUThzJbPJ98RyZ+W2Le5DpliCDS
         3ogc1G1WRVffVELeFxTUK3uChWAIxP5Obn9TdlrRnsenBSbr6eJUuhHCMHflBazUqQ9j
         vgPU+1AJsFaPGoQ7304IBZjAk789m3pqPpE3uiAhyrvh9pKAEivptxrdG9V+jNpHUXWd
         CzpA==
X-Forwarded-Encrypted: i=1; AJvYcCVQdVbsdH9fMryThUbHFjBbitxeh1jKjf6RA7Q34lpjCDHA7tPOCQuXJsDBc3wQ+g9AI2HiIPUnbLFhuwooJA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxuXih6meUdJ/GAs7TgZr6amYXo7YmwfJfdKeskWAeoTlqrAqXF
	+FT3O0I9qwswPdZc/VnpwhWLNUeojVTfRsuSsQC3O0x1jNMAC3Fyuhl331cxvnNk5miZAjmSVkd
	cj7A6XyS9ZSbHudnQLor8V62fHv5dfsTJGDgjsWBEY74syjHf1C43jNk=
X-Google-Smtp-Source: AGHT+IGwcBUw4yOCvXnylSAKDctqIEhA20+2bUYCAgQcHwriGE4YMthIF81B25/L5DDW5mtRw8cXLzu/B8+kj6JIeF/yYbxeKsSl
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:3c05:b0:3d5:81aa:4d0a with SMTP id
 e9e14a558f8ab-3d7ec2020e0mr51049645ab.6.1744442285083; Sat, 12 Apr 2025
 00:18:05 -0700 (PDT)
Date: Sat, 12 Apr 2025 00:18:05 -0700
In-Reply-To: <B9F695AD-3447-4F18-AAB9-85E118ED2BE3@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67fa13ad.050a0220.379d84.0008.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] kernel BUG in bch2_fs_initialize
From: syzbot <syzbot+d10151bf01574a09a915@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, mmpgouride@gmail.com, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch but the reproducer is still triggering an issue:
unregister_netdevice: waiting for DEV to become free

unregister_netdevice: waiting for batadv0 to become free. Usage count = 3


Tested on:

commit:         01c6df60 Add linux-next specific files for 20250411
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=16c2f7e4580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=db03cefa26ecf825
dashboard link: https://syzkaller.appspot.com/bug?extid=d10151bf01574a09a915
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
patch:          https://syzkaller.appspot.com/x/patch.diff?x=13ad00cc580000

