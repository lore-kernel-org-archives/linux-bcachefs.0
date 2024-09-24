Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 109D1823C3
	for <linux-bcachefs@vger.kernel.org>; Tue, 24 Sep 2024 06:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727160906; cv=none; b=rTjWSCP9Tp+e+8bYKO2DFovXVz4l6ejjzn/JgoxnpaWl5rQB9f87lQiWdQKWY14J97qJmldclwmrxleQ7DXAQAV5waU61e54xSSbMlHUbv5XXFS5uqX+Ku+wpz1Q76hSGVNHQR47FJkRpHj4wU8owRW18gpim2G4YVsO3E/IB4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727160906; c=relaxed/simple;
	bh=DXGpbj1ToJvfSYNwXGeIB9UHOP0jaudES3ZJSVFcrqY=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=qjyXyojGmf1NPleNqfV3732S5W9jLwdUpVxE9Mo1ozc99gZSCAqJv3MrnCMJG1uMkc9ie4Kan+jcMnvAKTqzl8gGLIsfu9mKl31aoapqqvo8Ivdt1OocXJr+heGS/IDFUdl48E7Q6fSNBfJpuziiRES/0Wjbgg4UO4aOrmMyOsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-3a0cbb9da2aso39682125ab.0
        for <linux-bcachefs@vger.kernel.org>; Mon, 23 Sep 2024 23:55:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727160904; x=1727765704;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GKvHsFQknHqx+vatCkVKyyBXSb1uz2e39SOBMypDJQo=;
        b=oqUxmiu4AJZn26F0jz+AUUZ4MHYPF9QtZTSGF4e31RNSD2jMkzgap54EMpvhQBDs8R
         3Ya0g5Em8UazgahugCoSRv37d9Ecp5XPtSfTEyjqyul9v6D255m0B0rsQTAzHwBW+oAG
         RSHVrzbxIFNegmWGeHnWGGKdd2/x6JaZgg1saEv7T7bx5tTMSojLL4hgklaprweKa5cq
         OvZ92Qzz8KQCMP7Pf1PcZJjrfnW4m6RDa8NJIaYUwTKALLiLf8X2prKblYQyBI/RKrjq
         DcpiISMQhXd/g7h0l/bTx3NopCIF+n8t9rDMrpMBLe7JB4QjHl88CtGKiVkNRW5OMqW7
         LXuA==
X-Forwarded-Encrypted: i=1; AJvYcCUrZxfhd6HXwthXv5DLi4NgSfhXACVwkSkV3ClOp85aq4ggPrjMjECQuxItC8Mg45Zfu0sxpnijwDmHSUGJfw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxu2YrX5ODeOXE0vMDRLowPMuRFzDGpxxtola5QwaDxTpNWiyKY
	ui+7skmXAi4dhYqU4yNOw1eWErdhsWuahIdVF5HrYkRhtwVCoZhLeS1GqfzOPoj3SDHVJ1WH8Ks
	cepngDkIPYrpq/Ta0WMh1vm6afE+jtpiavhGc7GLMmpDD+wALfNFoO2c=
X-Google-Smtp-Source: AGHT+IGKtjpCciSdXE5HJt/EM4Vx6pkc1TT0sO5zDA/SxUcwY0Mx8bEGvzebSjafPTkkgJm4T6WIAGn6ayk1y+dfullL8XESC5iI
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:170e:b0:3a0:926a:8d31 with SMTP id
 e9e14a558f8ab-3a0c8d091aemr105206855ab.16.1727160904099; Mon, 23 Sep 2024
 23:55:04 -0700 (PDT)
Date: Mon, 23 Sep 2024 23:55:04 -0700
In-Reply-To: <66eea5a2.050a0220.3195df.004b.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <66f26248.050a0220.3eed3.0023.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] general protection fault in __copy_super
From: syzbot <syzbot+18a5c5e8a9c856944876@syzkaller.appspotmail.com>
To: bfoster@redhat.com, djahchankoike@gmail.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has bisected this issue to:

commit 03ef80b469d5d83530ce1ce15be78a40e5300f9b
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Sat Sep 23 22:41:51 2023 +0000

    bcachefs: Ignore unknown mount options

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1057d107980000
start commit:   f8eb5bd9a818 mm: fix build on 32-bit targets without MAX_P..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=1257d107980000
console output: https://syzkaller.appspot.com/x/log.txt?x=1457d107980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=74ffdb3b3fad1a43
dashboard link: https://syzkaller.appspot.com/bug?extid=18a5c5e8a9c856944876
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=174cca27980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15a3619f980000

Reported-by: syzbot+18a5c5e8a9c856944876@syzkaller.appspotmail.com
Fixes: 03ef80b469d5 ("bcachefs: Ignore unknown mount options")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
