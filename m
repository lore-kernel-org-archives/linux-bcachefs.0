Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 382722528FC
	for <linux-bcachefs@vger.kernel.org>; Wed,  9 Apr 2025 17:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744218125; cv=none; b=sWB+oWIVz/jt0ULIqpVRggOePm24HiacKQ9NQpWJxIWDosJT/1lB2lW5Iu99uqt4kHWWM4q2u6Be+sQTlnicY1I+NCpmxWQ3lq+lJDy/5rkd729JfHw8u8z54IeQ4wbh4D4BM7TnWdWwpX0wmgM99z82XGVvrWBW3IbObwJ1WMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744218125; c=relaxed/simple;
	bh=N/Q29EyrkUNjSpHrD6c7uvmrA++bL2w5w55MY0tEk6M=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=aMwNHIOPowosMNx0kJGz3jOLUKxO4PWdFgXu53yeK0CjEL+VpxsYucCzqNOgi+hS+YDOmwmGRAMIGaQJ3gH0GJehYglGpacj0CiYqPDW5KIESVFmeFZ0WTB2jvwSAvpx2fy0VINR2GL+WJ6E8KdcDnCBF7y1GC0BbDcG5iJKXD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3d586b968cfso151503205ab.1
        for <linux-bcachefs@vger.kernel.org>; Wed, 09 Apr 2025 10:02:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744218123; x=1744822923;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Uh2RDEiNjcy7yVV8K/XknWCLeT7CD0KwGkJWuruTDKU=;
        b=wmZNClsqMSB+g15CZ2GR0kRsbDBaWqerz15B3L52MDWJIJb8iBRSqiG2/zZAf2tjt8
         EZQdHda38UN9ygjb2/dkv0COL5jNxN5hgG/BElJ7xVhuGKWdUF7V7ydhJK0cZLlikiNw
         NEa8PxNiLymvvMWEqeeekHBcmp2mqk0iFKyfWZDyoNotDSACrE/kCBXDog0du343lU/c
         D33y4Wc5qFtcuWP1R+RSFkmoQy1jr2veDfRwtGn6mHRXkfCLFQe2DMKnaohMkISgLnKI
         MQ8IyYF5RbkcWZi8EU9mwCFFWMeDSugviqFQ2u9sPS5SHR+pTRPSmWkp/g5xl+309xRk
         5w0Q==
X-Forwarded-Encrypted: i=1; AJvYcCXi7Hp/uYTQHU04xB8RQI9fr7MNS0ZqJHwPxBImAuI03QSwr1sVflmqZNBfkDd+DkyU01xS+ExMthU+xXuVeQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy7i9CAYF3kSdvzO+PoWQnuw6RJnRU7eldyGPGGtGhN/tSas5tI
	dvTQA7ybrkNoubOfXFBNRCiDH6F9xoKgemk3VNVTJ0+UkitW+13MvXqwPscPX+eRBA1SNkGTrpi
	TEyIDo4dps6ZeIi+73VLfjkaHR29vgvfX4F5GRBbA4vVnV7n62VsBoUc=
X-Google-Smtp-Source: AGHT+IF0p9jxNcDd6PbkOO2yCKjngIRE3FTMwu/mbuIiVBJBjJOR+yItnAYXFBtmxHqRTomyXV+LFwIPkW83vSGmMmmb2Jf1hm5A
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:3004:b0:3d3:fdb8:1796 with SMTP id
 e9e14a558f8ab-3d7b45fd15emr33844205ab.2.1744218123325; Wed, 09 Apr 2025
 10:02:03 -0700 (PDT)
Date: Wed, 09 Apr 2025 10:02:03 -0700
In-Reply-To: <m25xjds4e2.fsf@posteo.net>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67f6a80b.050a0220.25d1c8.0007.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] WARNING in bch2_dev_free
From: syzbot <syzbot+aec9606169fbc3a12ca6@syzkaller.appspotmail.com>
To: charmitro@posteo.net, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch but the reproducer is still triggering an issue:
unregister_netdevice: waiting for DEV to become free

unregister_netdevice: waiting for batadv0 to become free. Usage count = 3


Tested on:

commit:         a2458824 Merge tag 'linux_kselftest-kunit-6.15-rc2' of..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=153ffb4c580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=fb8650d88e9fb80f
dashboard link: https://syzkaller.appspot.com/bug?extid=aec9606169fbc3a12ca6
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
patch:          https://syzkaller.appspot.com/x/patch.diff?x=17b7fb4c580000

