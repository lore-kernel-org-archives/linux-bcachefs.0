Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 038601A4E9B;
	Tue, 24 Sep 2024 11:08:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727176124; cv=none; b=NQVisjKnFxGRn4Y09GBBVMcP9TC2QBN6OlZo1rWP7Y7OzScaGYy5KX9NIGzjhUA8+qNoR49HxbPA2p40DTmyKMkRiSf9N2N7jOdW/+DcVWQ9y9KGsGzp8/s/hHiTblOolfwjEhpXzgGxWmsVxVeargN+j9Yr/OY8GQyjrkiJb8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727176124; c=relaxed/simple;
	bh=FybeSDboZcWVGXYw9pGPRkzUvAtaqCgz6wIJmEAq58o=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Ok5FdPqKd/NE/3QcbWsZNJWTrKqufawLsptbuglRseKjXQWT2vWXPooiy7tlqj9VpDIh3cgOn9hWzKWP8WU30G0WNbj48YMk0kxMDqJHVHeI/uYlT6L44NzHtY+iZo9lm5UmVcNofs4LPLgh6Jdm0r9Dd3+UnYSXZhFuZ2JB7lw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=okhdzdAp; arc=none smtp.client-ip=117.135.210.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="okhdzdAp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=gdJaG
	NwSbHqqkzoWIdq9rWGNNFlj6STaCI87rtVcdd8=; b=okhdzdApBVk1GeAn8VmUt
	TV2FddDDElp50g1HZps1CBqj2uN1lzTXPCzxUokns1nxThvqxGoaaYaExgAwGbTp
	hulY26W1VdPnnu4iNIDQ2mVQakwyJF3CEY8PIp/fUBuhhTG/JtvwjWFIiG+VP0Ze
	4o7WIxEmulGswV42hOHhvE=
Received: from localhost.localdomain (unknown [111.35.191.143])
	by gzga-smtp-mta-g3-2 (Coremail) with SMTP id _____wDnioWXnfJmNKc+Kw--.11017S4;
	Tue, 24 Sep 2024 19:08:24 +0800 (CST)
From: David Wang <00107082@163.com>
To: kent.overstreet@linux.dev
Cc: 00107082@163.com,
	linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [BUG?] bcachefs performance: read is way too slow when a file has no overwrite.
Date: Tue, 24 Sep 2024 19:08:07 +0800
Message-Id: <20240924110807.28788-1-00107082@163.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240907103437.71139-1-00107082@163.com>
References: <20240907103437.71139-1-00107082@163.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDnioWXnfJmNKc+Kw--.11017S4
X-Coremail-Antispam: 1Uf129KBjvJXoW3Wr4UCr17KFWUWF4xJw1kKrg_yoW7Wryfp3
	4ftF17GF48tr1UJw17tr1UJFyUJr45Aa4UAr17JFy8Jw1UArn8Xry7Wr4rtFyUAr9xXry5
	tF9Fqr18tF15Jw7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0JUfl1DUUUUU=
X-CM-SenderInfo: qqqrilqqysqiywtou0bp/1tbiMxVkqmbyZ6cKNAACsA

Hi, 

At 2024-09-07 18:34:37, "David Wang" <00107082@163.com> wrote:
>At 2024-09-07 01:38:11, "Kent Overstreet" <kent.overstreet@linux.dev> wrote:
>>That's because checksums are at extent granularity, not block: if you're
>>doing O_DIRECT reads that are smaller than the writes the data was
>>written with, performance will be bad because we have to read the entire
>>extent to verify the checksum.
>
>

>Based on the result:
>1. The row with prepare-write size 4K stands out, here.
>When files were prepaired with write size 4K, the afterwards
> read performance is worse.  (I did double check the result,
>but it is possible that I miss some affecting factors.);
>2. Without O_DIRECT, read performance seems correlated with the difference
> between read size and prepare write size, but with O_DIRECT, correlation is not obvious.
>
>And, to mention it again, if I overwrite the files **thoroughly** with fio write test
>(using same size), the read performance afterwards would be very good:
>

Update some IO pattern (bio start address and size, in sectors, address&=-address),
between bcachefs and block layer:

4K-Direct-Read a file created by loop of `write(fd, buf, 1024*4)`:
+--------------------------+--------+--------+--------+--------+---------+
|       offset\size        |   1    |   6    |   7    |   8    |   128   |
+--------------------------+--------+--------+--------+--------+---------+
|                        1 | 0.015% | 0.003% |   -    |   -    |    -    |
|                       10 | 0.008% | 0.001% |   -    | 0.000% |    -    |
|                      100 | 0.003% | 0.001% | 0.000% |   -    |    -    |
|                     1000 | 0.002% | 0.000% |   -    |   -    |    -    |
|                    10000 | 0.001% | 0.000% |   -    |   -    |    -    |
|                   100000 | 0.000% |   -    |   -    |   -    |    -    |
|                  1000000 | 0.000% |   -    |   -    |   -    |    -    |
|                 10000000 | 0.000% |   -    |   -    |   -    | 49.989% |
|                100000000 | 0.001% |   -    |   -    |   -    | 24.994% |
|               1000000000 |   -    |   -    |   -    |   -    | 12.486% |
|              10000000000 |   -    |   -    |   -    |   -    |  6.253% |
|             100000000000 |   -    |   -    |   -    |   -    |  3.120% |
|            1000000000000 |   -    | 0.000% |   -    |   -    |  1.561% |
|           10000000000000 |   -    |   -    |   -    |   -    |  0.781% |
|          100000000000000 |   -    |   -    |   -    |   -    |  0.391% |
|         1000000000000000 |   -    |   -    |   -    |   -    |  0.195% |
|        10000000000000000 |   -    |   -    |   -    |   -    |  0.098% |
|       100000000000000000 |   -    |   -    |   -    |   -    |  0.049% |
|      1000000000000000000 |   -    |   -    |   -    |   -    |  0.024% |
|     10000000000000000000 |   -    |   -    |   -    |   -    |  0.013% |
|    100000000000000000000 |   -    |   -    |   -    |   -    |  0.006% |
|  10000000000000000000000 |   -    |   -    |   -    |   -    |  0.006% |
+--------------------------+--------+--------+--------+--------+---------+

4K-Direct-Read a file created by `dd if=/dev/urandom ...`
+--------------------------+---------+
|       offset\size        |   128   |
+--------------------------+---------+
|                 10000000 | 50.003% |
|                100000000 | 24.993% |
|               1000000000 | 12.508% |
|              10000000000 |  6.252% |
|             100000000000 |  3.118% |
|            1000000000000 |  1.561% |
|           10000000000000 |  0.782% |
|          100000000000000 |  0.391% |
|         1000000000000000 |  0.196% |
|        10000000000000000 |  0.098% |
|       100000000000000000 |  0.049% |
|      1000000000000000000 |  0.025% |
|     10000000000000000000 |  0.012% |
|    100000000000000000000 |  0.006% |
|   1000000000000000000000 |  0.006% |
+--------------------------+---------+

4K-Direct-Read a file which is *overwritten* by random fio 4k-direct-write for 10 minutes
+--------------------------+---------+--------+--------+
|       offset\size        |    8    |   16   |   24   |
+--------------------------+---------+--------+--------+
|                     1000 | 49.912% | 0.028% | 0.004% |
|                    10000 | 25.024% | 0.018% | 0.001% |
|                   100000 | 12.507% | 0.012% | 0.001% |
|                  1000000 |  6.273% | 0.002% | 0.001% |
|                 10000000 |  3.121% | 0.002% |   -    |
|                100000000 |  1.548% |   -    |   -    |
|               1000000000 |  0.778% | 0.001% |   -    |
|              10000000000 |  0.386% |   -    |   -    |
|             100000000000 |  0.194% |   -    |   -    |
|            1000000000000 |  0.098% |   -    |   -    |
|           10000000000000 |  0.046% |   -    |   -    |
|          100000000000000 |  0.023% |   -    |   -    |
|         1000000000000000 |  0.011% |   -    |   -    |
|        10000000000000000 |  0.006% |   -    |   -    |
|       100000000000000000 |  0.003% |   -    |   -    |
|      1000000000000000000 |  0.002% |   -    |   -    |
|     10000000000000000000 |  0.001% |   -    |   -    |
|  10000000000000000000000 |  0.000% |   -    |   -    |
+--------------------------+---------+--------+--------+


Those read of 1 sector size in the first IO pattern may need attention? (@Kent)
(The file was created via following code:
	#define _GNU_SOURCE
	#include <stdio.h>
	#include <fcntl.h>
	#include <unistd.h>

	#define KN 4
	char name[32];
	char buf[1024*KN];
	int main() {
		int i, m = 1024*1024/KN, k, fd;
		for (i=0; i<1; i++) {
			sprintf(name, "test.%d.0", i);
			fd = open(name, O_CREAT|O_DIRECT|O_SYNC|O_TRUNC|O_WRONLY);
			for (k=0; k<m; k++) write(fd, buf, sizeof(buf));
			close(fd);
		}
		return 0;
	}

I also collected latency between FS and BIO (submit_bio --> bio_endio),
 and did not observe difference between bcachefs and ext4, when extension size is mostly 4K.
On my SSD, one 4K-direct-read test even shows bcachefs usage is better:
 average 171086ns for ext4, 133304ns for bcachefs.

But the overall performance, from fio's point of view,
bcachefs is only half of ext4's, and cpu usage is much lower
than ext4: 60%- vs 90%+. 
(The bottleneck should be within bcachefs, I guess? But don't have
any idea of how to measure it.)

Glad to hear those new patches for 6.12,
https://lore.kernel.org/lkml/CAHk-=wh+atcBWa34mDdG1bFGRc28eJas3tP+9QrYXX6C7BX0JQ@mail.gmail.com/T/#m27c78e1f04c556ab064bec06520b8d7fcf4518c5
really looks promising, looking forward to test it next week~!!


Thanks
David

