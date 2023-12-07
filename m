Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4EF3137
	for <linux-bcachefs@vger.kernel.org>; Wed,  6 Dec 2023 23:47:20 -0800 (PST)
Received: by a3.inai.de (Postfix, from userid 25121)
	id 70B7A5877546F; Thu,  7 Dec 2023 08:47:16 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by a3.inai.de (Postfix) with ESMTP id 6E10460C23DC0;
	Thu,  7 Dec 2023 08:47:16 +0100 (CET)
Date: Thu, 7 Dec 2023 08:47:16 +0100 (CET)
From: Jan Engelhardt <jengelh@inai.de>
To: Daniel Hill <daniel@gluo.nz>
cc: linux-bcachefs@vger.kernel.org
Subject: bcachefs-tools 1.3.5 FTBFS
Message-ID: <rpq876s0-37r5-5099-6q6r-p3n36r7rr701@vanv.qr>
User-Agent: Alpine 2.26 (LSU 649 2022-06-02)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII


With glibc 2.31, bcachefs-tools 314ce7d (tag: v1.3.5) cannot be built:

[   30s] linux/shrinker.c: In function 'run_shrinkers':
[   30s] linux/shrinker.c:72:9: error: variable 'malloc_info' has initializer but incomplete type
[   30s]   struct mallinfo2 malloc_info = mallinfo2();
[   30s]          ^~~~~~~~~

This is a glibc-2.34 specific feature.
