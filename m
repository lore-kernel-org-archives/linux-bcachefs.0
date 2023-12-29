Received: from smtp.carlthompson.net (charon.carlthompson.net [45.77.7.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E0A3137F
	for <linux-bcachefs@vger.kernel.org>; Fri, 29 Dec 2023 01:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=carlthompson.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=carlthompson.net
Received: from mail.carlthompson.net (mail.home [10.35.20.252])
	(Authenticated sender: cet@carlthompson.net)
	by smtp.carlthompson.net (Postfix) with ESMTPSA id 0F8A8140DED32
	for <linux-bcachefs@vger.kernel.org>; Thu, 28 Dec 2023 17:42:55 -0800 (PST)
Date: Thu, 28 Dec 2023 17:42:54 -0800 (PST)
From: "Carl E. Thompson" <list-bcachefs@carlthompson.net>
To: "linux-bcachefs@vger.kernel.org" <linux-bcachefs@vger.kernel.org>
Message-ID: <333226600.445.1703814174894@mail.carlthompson.net>
Subject: bcachefs Posix ACLs
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

Hello, the default kernel options for bcachefs do not enable Posix ACLs. Some distributions' kernels' builds simply use the defaults selected by the filesystem. This means that for bcachefs by default on those kernels Posix ACLs can't be used (unless the users build the kernel for themselves or find a different source for the kernel).

This is not really a bug but a question: Is this intentional and desired? Or should the default build options for bcachefs be changed so that Posix ACLs are enabled by default?

The same questions could be asked about quotas as well.

Thank you,
Carl Thompson
