Received: from smtp.carlthompson.net (charon.carlthompson.net [45.77.7.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89E991096C
	for <linux-bcachefs@vger.kernel.org>; Thu, 28 Dec 2023 23:12:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=carlthompson.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=carlthompson.net
Received: from mail.carlthompson.net (mail.home [10.35.20.252])
	(Authenticated sender: cet@carlthompson.net)
	by smtp.carlthompson.net (Postfix) with ESMTPSA id 2E478140DED0F
	for <linux-bcachefs@vger.kernel.org>; Thu, 28 Dec 2023 15:12:56 -0800 (PST)
Date: Thu, 28 Dec 2023 15:12:56 -0800 (PST)
From: "Carl E. Thompson" <list-bcachefs@carlthompson.net>
To: "linux-bcachefs@vger.kernel.org" <linux-bcachefs@vger.kernel.org>
Message-ID: <374982675.411.1703805176017@mail.carlthompson.net>
Subject: bcachefs snapshots silently ignore read-only flag
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

Hello, bcachefs silently ignores the read-only option (-r) without notice or warning when creating snapshots. This could lead to unintentional data loss if snapshots are used as a source for backups or copies that are supposed to reflect the subvolume / filesystem at the time the snapshot was taken.

Here is an example:
---
[carl@clip test]$ bcachefs subvolume create subvol

[carl@clip test]$ echo "Test" > subvol/file

[carl@clip test]$ bcachefs subvolume snapshot -r subvol read-only_snapshot

[carl@clip test]$ cat read-only_snapshot/file 
Test

[carl@clip test]$ echo "This shouldn't work" > read-only_snapshot/file 

[carl@clip test]$ cat read-only_snapshot/file 
This shouldn't work
---

IMO, something like a read-only option should hard fail if it does not succeed and silently failing to read/write is a very bad idea.

Thank you,
Carl Thompson
