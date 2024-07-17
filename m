Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com [209.85.210.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A79146FC5
	for <linux-bcachefs@vger.kernel.org>; Wed, 17 Jul 2024 03:22:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721186543; cv=none; b=KoVTW+GzNLVRz1x57UP7TPLPMBcaDy8pdbOxIr7Ggj5hju6JSmqNR7stINw2aWdwMwp1P2dxhrX+lOVJ/SmfBYm1iMKOow1sliOUrbrVaONtaqrlShogoEFbu+F5HV7NJCfWna0jlCpzmTOV5SR/MXX+NolsgOSIhHWZXaD4d2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721186543; c=relaxed/simple;
	bh=zIA+ydf1PUI1qpLYj7SmRNQxz+1MQKJSvu9wxUSzZ+I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GluNropNCyjeq7+5glk3shN1NAhapHdSzyF/JAUVneT4602Jl/lDB7gWp6FzUgTfTzQ1nE2jawsF7wQI+R/sBaZ+yW6nSzAXiaWCLG4ebdYM3Xy2bSofyaLSZHnmYfg6hAsVSluzwuxMknz56UtX2RbiXMI+egP6K88CXwSDx98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=OO/FJb/M; arc=none smtp.client-ip=209.85.210.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="OO/FJb/M"
Received: by mail-ot1-f50.google.com with SMTP id 46e09a7af769-70847d0cb1fso3478828a34.3
        for <linux-bcachefs@vger.kernel.org>; Tue, 16 Jul 2024 20:22:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1721186540; x=1721791340; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=LTLglTuhYReaAcbeDy1zm24fFRaIm0NH/Z09mXQPel4=;
        b=OO/FJb/M1H5bdcu3+dsAC1t9Ej7/ZZhHdYoc7nSWpkAXdeE51PwG/RLKAhSQPZLhGj
         /IdSP0Acikj2lr66Ybzs9kWxVg44XVPbzfVQewD9KfOaAZ0fC2xrS25ggL34VCOrddbo
         37KA/3xNdNPIZO8T0JMwF/QGIlkdkG3kukMDGkt4Uf1StjE0MRiBXnC7u7VjsNLw3XJt
         f518cRZVNMaARNKMiP8of3SErQWwbnAJd2J8Kqtl4gjjLUwjs8bgPvCetDKqIyJ6Pl6i
         lMtcmU0P/v6ZW9JuAr2mj/5aF3xmiY6X47gS9V1kjKtb9a37C2fOzbeOqmFZ4zNVq/pz
         Rwqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721186540; x=1721791340;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LTLglTuhYReaAcbeDy1zm24fFRaIm0NH/Z09mXQPel4=;
        b=Ydq3dYhqeP4Gdfj62YBOiBG9yqc/gatwh6LP8BLN3O9NWlLVCtwO6OmPhHqdp7ZUWm
         Bif7g+qGAuqOjMBIYEiDnRJrEiJ43jnEVCI6H51YJHZHrnR57I7/p58kZ5IhzJlMOnXy
         K2gkDx21f3xVkU8s4GpWKFj1e5kEV/ngueNw/UYO1NW052mDNMjELDsW0MXfWru4JGJ6
         pHhrEDj4GB4tRwDGQKI9SehvaZlJ8/L97zmL9P5gXmgpTUjsEoXxB6sXRFxXk8/Pvs5I
         dgtGDk3XMpLfyxNSqeiAnX6XwQ1TC6qi6oiTDw73AdZk4Uzmm15Ky/YXJCPwWeq2utMY
         lFaw==
X-Forwarded-Encrypted: i=1; AJvYcCXnRwJZip0GNiWDWXeQcW6f26d4qdTymVpLgCkD0y6QLK7nEGmAlEL3MdRZwaZ89j87yT+spYJPLxm+CPQSf0zSCcmPGHAzdGNhJUKDipw=
X-Gm-Message-State: AOJu0YwLlbfI3+DkLIXmaRRlhMzJF2kkrjQT1fqZtl20539hp9Op9NWz
	ftF/5nthvrASAYdHxzCGJdoryMuwQs7VdP/GZwZuM24CH4mhlsibLWMtQxg5zx8zHFRz1TBPOae
	o
X-Google-Smtp-Source: AGHT+IFXeHeMuke8lsM6BFPFGdjKJg7M732kbmnVl4P+ExeKXv1Un5svTidVLiv8/kih2WzC5cFrVQ==
X-Received: by 2002:a05:6830:6a91:b0:704:485b:412b with SMTP id 46e09a7af769-708e37e1ab2mr445196a34.20.1721186539610;
        Tue, 16 Jul 2024 20:22:19 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-32-121.pa.nsw.optusnet.com.au. [49.179.32.121])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-70b7eb9c922sm7096176b3a.40.2024.07.16.20.22.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jul 2024 20:22:19 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sTvFA-001166-2M;
	Wed, 17 Jul 2024 13:22:16 +1000
Date: Wed, 17 Jul 2024 13:22:16 +1000
From: Dave Chinner <david@fromorbit.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: =?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>,
	Paul Moore <paul@paul-moore.com>, Brian Foster <bfoster@redhat.com>,
	linux-bcachefs@vger.kernel.org,
	syzbot <syzbot+34b68f850391452207df@syzkaller.appspotmail.com>,
	gnoack@google.com, jmorris@namei.org, linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org, serge@hallyn.com,
	syzkaller-bugs@googlegroups.com, linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [syzbot] [lsm?] WARNING in current_check_refer_path - bcachefs
 bug
Message-ID: <Zpc46HEacI/wd7Rg@dread.disaster.area>
References: <000000000000a65b35061cffca61@google.com>
 <CAHC9VhT_XpUeaxtkz0+4+YbWgK6=NDeDQikmPVYZ=RXDt+NOgw@mail.gmail.com>
 <20240714.iaDuNgieR9Qu@digikod.net>
 <4hohnthh54adx35lnxzedop3oxpntpmtygxso4iraiexfdlt4d@6m7ssepvjyar>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4hohnthh54adx35lnxzedop3oxpntpmtygxso4iraiexfdlt4d@6m7ssepvjyar>

On Sun, Jul 14, 2024 at 03:51:17PM -0400, Kent Overstreet wrote:
> cc'ing linux-xfs, since I'm sure this has come up there and bcachefs and
> xfs verify and fsck are structured similararly at a very high level -
> I'd like to get their input.
> 
> On Sun, Jul 14, 2024 at 09:34:01PM GMT, Mickaël Salaün wrote:
> > On Fri, Jul 12, 2024 at 10:55:11AM -0400, Paul Moore wrote:
> > > On Thu, Jul 11, 2024 at 5:53 PM syzbot
> > > <syzbot+34b68f850391452207df@syzkaller.appspotmail.com> wrote:
> > > >
> > > > Hello,
> > > >
> > > > syzbot found the following issue on:
> > > >
> > > > HEAD commit:    8a03d70c27fc Merge remote-tracking branch 'tglx/devmsi-arm..
> > > > git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
> > > > console output: https://syzkaller.appspot.com/x/log.txt?x=174b0e6e980000
> > > > kernel config:  https://syzkaller.appspot.com/x/.config?x=15349546db652fd3
> > > > dashboard link: https://syzkaller.appspot.com/bug?extid=34b68f850391452207df
> > > > compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
> > > > userspace arch: arm64
> > > > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13cd1b69980000
> > > > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12667fd1980000
> > > >
> > > > Downloadable assets:
> > > > disk image: https://storage.googleapis.com/syzbot-assets/efb354033e75/disk-8a03d70c.raw.xz
> > > > vmlinux: https://storage.googleapis.com/syzbot-assets/c747c205d094/vmlinux-8a03d70c.xz
> > > > kernel image: https://storage.googleapis.com/syzbot-assets/5641f4fb7265/Image-8a03d70c.gz.xz
> > > > mounted in repro: https://storage.googleapis.com/syzbot-assets/4e4d1faacdef/mount_0.gz
> > > >
> > > > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > > > Reported-by: syzbot+34b68f850391452207df@syzkaller.appspotmail.com
> > > >
> > > > bcachefs (loop0): resume_logged_ops... done
> > > > bcachefs (loop0): delete_dead_inodes... done
> > > > bcachefs (loop0): done starting filesystem
> > > > ------------[ cut here ]------------
> > > > WARNING: CPU: 0 PID: 6284 at security/landlock/fs.c:971 current_check_refer_path+0x4e0/0xaa8 security/landlock/fs.c:1132
> > > 
> > > I'll let Mickaël answer this for certain, but based on a quick look it
> > > appears that the fs object being moved has a umode_t that Landlock is
> > > not setup to handle?
> > 
> > syzbot found an issue with bcachefs: in some cases umode_t is invalid (i.e.
> > a weird file).
> > 
> > Kend, Brian, you'll find the incorrect filesystem with syzbot's report.
> > Could you please investigate the issue?
> > 
> > Here is the content of the file system:
> > # losetup --find --show mount_0
> > /dev/loop0
> > # mount /dev/loop0 /mnt/
> > # ls -la /mnt/
> > ls: cannot access '/mnt/file2': No such file or directory
> > ls: cannot access '/mnt/file3': No such file or directory
> > total 24
> > drwxr-xr-x 4 root root   0 May  2 20:21 .
> > drwxr-xr-x 1 root root 130 Oct 31  2023 ..
> > drwxr-xr-x 2 root root   0 May  2 20:21 file0
> > ?rwxr-xr-x 1 root root  10 May  2 20:21 file1
   ^^^

That's an unknown file type. (i.e. i_mode & S_IFMT is invalid)

> > -????????? ? ?    ?      ?            ? file2
> > -????????? ? ?    ?      ?            ? file3
> > -rwxr-xr-x 1 root root 100 May  2 20:21 file.cold
> > drwx------ 2 root root   0 May  2 20:21 lost+found
> > # stat /mnt/file1
> >   File: /mnt/file1
> >   Size: 10              Blocks: 8          IO Block: 4096   weird file
> > Device: 7,0     Inode: 1073741824  Links: 1
> > Access: (0755/?rwxr-xr-x)  Uid: (    0/    root)   Gid: (    0/    root)
> > Access: 2024-05-02 20:21:07.747039697 +0000
> > Modify: 2024-05-02 20:21:07.747039697 +0000
> > Change: 2024-05-02 20:21:07.747039697 +0000
> >  Birth: 2024-05-02 20:21:07.747039697 +0000
> 
> Ok, this is an interesting one.
> 
> So we don't seem to be checking for invwalid i_mode at all - that's a bug.

XFS verifies part of the S_IFMT part of the mode when it is read
from disk.  xfs_dinode_verify() does:

	mode = be16_to_cpu(dip->di_mode);
        if (mode && xfs_mode_to_ftype(mode) == XFS_DIR3_FT_UNKNOWN)
                return __this_address;

So if the type of the inode is not a valid XFS inode type, the whole
inode will get rejected as corrupt. i.e. the same issue on XFS
would return a corruption error for file1, not just file2 and file3.

> But if we don't want to be exposing invalid i_modes at all, that's
> tricky, since we (currently) can only repair when running fsck. "This is
> invalid and we never want to expose this" checks are done in bkey
> .invalid methods, and those can only cause the key to be deleted - we
> can't run complex repair in e.g. btree node read, and that's what would
> be required here (e.g. checking the extents and dirents btrees to guess
> if this should be a regular file or a directory).

Xfs online repair looks up the parent directory dirent for the inode
and grabs the ftype from the dirent to reset the mode....

> I wasn't planning on doing that for awhile, because I'm waiting on
> getting comprehensive filesystem error injection merged so we can make
> sure those repair paths are all well tested before running them
> automatically like that, but if this is a security issue perhaps as a
> special case we should do that now.
> 
> Thoughts?

Detect the bad mode on read, flag it as corruption and then the file
is inaccessible to users. Then you can take you time getting the
repair side of things right.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
