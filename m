Received: from smtp.carlthompson.net (charon.carlthompson.net [45.77.7.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1EA51096C
	for <linux-bcachefs@vger.kernel.org>; Thu, 28 Dec 2023 22:53:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=carlthompson.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=carlthompson.net
Received: from mail.carlthompson.net (mail.home [10.35.20.252])
	(Authenticated sender: cet@carlthompson.net)
	by smtp.carlthompson.net (Postfix) with ESMTPSA id 35BB214006409
	for <linux-bcachefs@vger.kernel.org>; Thu, 28 Dec 2023 14:53:13 -0800 (PST)
Date: Thu, 28 Dec 2023 14:53:12 -0800 (PST)
From: "Carl E. Thompson" <list-bcachefs@carlthompson.net>
To: "linux-bcachefs@vger.kernel.org" <linux-bcachefs@vger.kernel.org>
Message-ID: <2122357159.374.1703803993005@mail.carlthompson.net>
Subject: bcachefs can't mount filesystems with duplicate UUIDs (including
 snapshots and backups)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Priority: 3
Importance: Normal
X-Mailer: Open-Xchange Mailer v7.10.6-Rev53
X-Originating-Client: open-xchange-appsuite

Hello, there is an issue (bug or missing needed feature) in bcachefs where it appears to be impossible to mount a bcachefs filesystem which has the same UUID as an already mounted filesystem. This is necessary in many forensic and online backup scenarios. For example, in my personal and professional workflows crash-consistent online backups are made by mounting thin LVM snapshots. This seems to be impossible with bcachefs because it lacks a mount option to bypass the unique UID test and the mount fails with an `Invalid argument` message from mount on the command line and a `filesystem UUID already open` message in the kernel log.

Other filesystems have a mount option specifically to allow this. For example, XFS has a `nouuid` option. I believe that bcachefs needs a similar option to be broadly useful, particularly for non-hobbyist use cases. (If it makes it easier to implement IMO for most uses if the new mount option to bypass the UUID check implied the `nochanges` option that would be fine.)

I am aware that I could just use bcachefs native snapshots instead (when they are proven to work reliably). However, a large part of the reason I use LVM is because it gives me a consistent interface for snapshots (and thus for backups) for all the different filesystems I use. Retooling to special-case for bcachefs would require a lot of work and testing and would remove a huge benefit of this approach.

Thank you,
Carl Thompson
